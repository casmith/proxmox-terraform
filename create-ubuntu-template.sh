#!/bin/bash
set -e

echo "==================================="
echo "Ubuntu 24.04 Cloud-Init Template Creator"
echo "==================================="
echo ""
echo "This script will create an Ubuntu 24.04 cloud-init template in Proxmox"
echo "Run this script ON YOUR PROXMOX SERVER (not on your local machine)"
echo ""

# Configuration
TEMPLATE_ID=${1:-9000}
TEMPLATE_NAME="ubuntu-2404-cloudinit-template"
STORAGE=${2:-"local-lvm"}
MEMORY=2048
CORES=2
BRIDGE="vmbr0"

echo "Configuration:"
echo "  Template ID: $TEMPLATE_ID"
echo "  Template Name: $TEMPLATE_NAME"
echo "  Storage: $STORAGE"
echo "  Memory: ${MEMORY}MB"
echo "  Cores: $CORES"
echo "  Network Bridge: $BRIDGE"
echo ""

read -p "Continue with these settings? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Check if VM ID already exists
if qm status $TEMPLATE_ID &>/dev/null; then
    echo "Error: VM ID $TEMPLATE_ID already exists!"
    echo "Please choose a different ID or remove the existing VM"
    echo "Usage: $0 <template_id> <storage>"
    echo "Example: $0 9001 local-lvm"
    exit 1
fi

echo ""
echo "Step 1: Downloading Ubuntu 24.04 cloud image..."
cd /tmp
if [ ! -f noble-server-cloudimg-amd64.img ]; then
    wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
    echo "Download complete!"
else
    echo "Image already exists, skipping download."
fi

echo ""
echo "Step 2: Creating VM $TEMPLATE_ID..."
qm create $TEMPLATE_ID \
    --name $TEMPLATE_NAME \
    --memory $MEMORY \
    --cores $CORES \
    --net0 virtio,bridge=$BRIDGE

echo ""
echo "Step 3: Importing disk to storage '$STORAGE'..."
qm importdisk $TEMPLATE_ID noble-server-cloudimg-amd64.img $STORAGE

echo ""
echo "Step 4: Configuring VM hardware..."
# Attach the imported disk
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:vm-${TEMPLATE_ID}-disk-0

# Add cloud-init drive
qm set $TEMPLATE_ID --ide2 ${STORAGE}:cloudinit

# Set boot disk
qm set $TEMPLATE_ID --boot c --bootdisk scsi0

# Add serial console
qm set $TEMPLATE_ID --serial0 socket --vga serial0

# Enable QEMU guest agent
qm set $TEMPLATE_ID --agent enabled=1

# Set CPU type to host for better performance
qm set $TEMPLATE_ID --cpu host

# Enable hotplug for disk, network, and USB
qm set $TEMPLATE_ID --hotplug disk,network,usb

echo ""
echo "Step 5: Converting to template..."
qm template $TEMPLATE_ID

echo ""
echo "==================================="
echo "SUCCESS!"
echo "==================================="
echo ""
echo "Template created successfully!"
echo "  Template ID: $TEMPLATE_ID"
echo "  Template Name: $TEMPLATE_NAME"
echo ""
echo "You can now use this template in your Terraform configuration."
echo "Make sure your terraform.tfvars has:"
echo "  template_name = \"$TEMPLATE_NAME\""
echo ""
echo "Cleaning up..."
rm -f /tmp/noble-server-cloudimg-amd64.img
echo "Done!"
