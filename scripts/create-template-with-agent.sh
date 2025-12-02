#!/bin/bash
# Run this ON PROXMOX SERVER to create a proper Ubuntu template with qemu-guest-agent
set -e

TEMPLATE_ID=${1:-9000}
TEMPLATE_NAME="ubuntu-2404-cloudinit-template"
STORAGE=${2:-"local-lvm"}
MEMORY=2048
CORES=2
BRIDGE="vmbr0"

echo "============================================"
echo "Creating Ubuntu 24.04 Template with QEMU Agent"
echo "============================================"
echo ""
echo "Configuration:"
echo "  Template ID: $TEMPLATE_ID"
echo "  Template Name: $TEMPLATE_NAME"
echo "  Storage: $STORAGE"
echo "  Memory: ${MEMORY}MB"
echo "  Cores: $CORES"
echo "  Network Bridge: $BRIDGE"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Check if VM ID exists
if qm status $TEMPLATE_ID &>/dev/null; then
    echo "Error: VM ID $TEMPLATE_ID already exists!"
    echo "Please remove it first or choose a different ID"
    exit 1
fi

echo ""
echo "Step 1: Downloading Ubuntu 24.04 cloud image..."
cd /tmp
if [ ! -f noble-server-cloudimg-amd64.img ]; then
    wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
    echo "✓ Download complete"
else
    echo "✓ Image already exists, using cached version"
fi

echo ""
echo "Step 2: Creating base VM..."
qm create $TEMPLATE_ID \
    --name $TEMPLATE_NAME \
    --memory $MEMORY \
    --cores $CORES \
    --net0 virtio,bridge=$BRIDGE

echo ""
echo "Step 3: Importing disk..."
qm importdisk $TEMPLATE_ID noble-server-cloudimg-amd64.img $STORAGE

echo ""
echo "Step 4: Configuring VM hardware..."
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:vm-${TEMPLATE_ID}-disk-0
qm set $TEMPLATE_ID --ide2 ${STORAGE}:cloudinit
qm set $TEMPLATE_ID --boot c --bootdisk scsi0
qm set $TEMPLATE_ID --serial0 socket --vga serial0
qm set $TEMPLATE_ID --agent enabled=1
qm set $TEMPLATE_ID --cpu host

echo ""
echo "Step 5: Configuring cloud-init to install qemu-guest-agent..."
# Create a snippets directory if it doesn't exist
mkdir -p /var/lib/vz/snippets

# Create cloud-init user-data that installs qemu-guest-agent
cat > /var/lib/vz/snippets/user-data-qemu-agent.yaml << 'EOF'
#cloud-config
package_update: true
packages:
  - qemu-guest-agent
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
EOF

# Set the cloud-init cicustom to use our user-data
qm set $TEMPLATE_ID --cicustom "user=local:snippets/user-data-qemu-agent.yaml"

echo ""
echo "Step 6: Converting to template..."
qm template $TEMPLATE_ID

echo ""
echo "Step 7: Cleaning up..."
rm -f /tmp/noble-server-cloudimg-amd64.img

echo ""
echo "============================================"
echo "SUCCESS!"
echo "============================================"
echo ""
echo "Template $TEMPLATE_ID created successfully!"
echo ""
echo "This template includes:"
echo "  ✓ Ubuntu 24.04 LTS"
echo "  ✓ Cloud-init enabled"
echo "  ✓ QEMU guest agent (will be installed on first boot)"
echo "  ✓ Serial console"
echo ""
echo "When VMs are created from this template, qemu-guest-agent"
echo "will be automatically installed during the first boot via cloud-init."
echo ""
