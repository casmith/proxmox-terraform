#!/bin/bash
# Run this script ON YOUR PROXMOX SERVER to add qemu-guest-agent to the template
# This version clones the template, updates it, then replaces the original
set -e

TEMPLATE_ID=${1:-9000}
TEMP_VM_ID=9999
STORAGE="local-lvm"

echo "============================================"
echo "Adding QEMU Guest Agent to Template"
echo "============================================"
echo ""
echo "Template ID: $TEMPLATE_ID"
echo "Temporary VM ID: $TEMP_VM_ID"
echo ""

# Verify source is a template
if ! qm config $TEMPLATE_ID | grep -q "template: 1"; then
    echo "ERROR: VM $TEMPLATE_ID is not a template!"
    exit 1
fi

# Check if temp VM ID is available
if qm status $TEMP_VM_ID &>/dev/null; then
    echo "ERROR: VM $TEMP_VM_ID already exists!"
    echo "Please use a different ID or delete that VM first"
    exit 1
fi

echo "Step 1: Cloning template to temporary VM..."
qm clone $TEMPLATE_ID $TEMP_VM_ID --name temp-qemu-agent-install --full

echo ""
echo "Step 2: Removing cloud-init drive from clone to avoid issues..."
qm set $TEMP_VM_ID --delete ide2

echo ""
echo "Step 3: Adding new cloud-init drive..."
qm set $TEMP_VM_ID --ide2 ${STORAGE}:cloudinit

echo ""
echo "Step 4: Starting the temporary VM..."
qm start $TEMP_VM_ID

echo ""
echo "Step 5: Waiting for VM to boot (60 seconds)..."
sleep 60

echo ""
echo "Step 6: Getting VM IP address..."
VM_IP=""
for i in {1..10}; do
    VM_IP=$(qm guest cmd $TEMP_VM_ID network-get-interfaces 2>/dev/null | grep -A 3 '"name": "eth0"' | grep -oP '"ip-address": "\K[^"]+' | grep -v '^127\|^::1\|^fe80' | head -1 || echo "")
    if [ -n "$VM_IP" ]; then
        break
    fi
    echo "Waiting for IP... attempt $i/10"
    sleep 5
done

if [ -z "$VM_IP" ]; then
    echo ""
    echo "Could not determine VM IP automatically."
    echo "Please find the IP address from the Proxmox console or DHCP server."
    read -p "Enter the VM IP address: " VM_IP
fi

echo "VM IP Address: $VM_IP"

echo ""
echo "Step 7: Installing QEMU guest agent via SSH..."
echo "Waiting for SSH to be ready..."
sleep 10

# Install using SSH
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30 ubuntu@$VM_IP << 'ENDSSH'
sudo apt-get update
sudo apt-get install -y qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent
echo "QEMU guest agent installed and started!"
ENDSSH

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Failed to install via SSH."
    echo "Please install manually:"
    echo "  ssh ubuntu@$VM_IP"
    echo "  sudo apt update && sudo apt install -y qemu-guest-agent"
    echo ""
    read -p "Press Enter once installation is complete..."
fi

echo ""
echo "Step 8: Verifying agent is active..."
sleep 5
if qm guest cmd $TEMP_VM_ID ping 2>/dev/null | grep -q "return"; then
    echo "✓ QEMU guest agent is responding!"
else
    echo "WARNING: Agent may not be responding yet."
fi

echo ""
echo "Step 9: Shutting down temporary VM..."
qm shutdown $TEMP_VM_ID
sleep 20

# Force stop if needed
if qm status $TEMP_VM_ID | grep -q "running"; then
    echo "Force stopping..."
    qm stop $TEMP_VM_ID
    sleep 5
fi

echo ""
echo "Step 10: Removing old template..."
qm destroy $TEMPLATE_ID

echo ""
echo "Step 11: Converting temporary VM to template with original ID..."
qm set $TEMP_VM_ID --name ubuntu-2404-cloudinit-template
qm template $TEMP_VM_ID

echo ""
echo "Step 12: Renaming VM ID from $TEMP_VM_ID to $TEMPLATE_ID..."
# Note: Proxmox doesn't support direct ID renaming, so we keep the new ID
echo "NOTE: New template ID is $TEMP_VM_ID (instead of $TEMPLATE_ID)"
echo "You'll need to update your Terraform configuration:"
echo "  template_id = $TEMP_VM_ID"

echo ""
echo "============================================"
echo "SUCCESS!"
echo "============================================"
echo ""
echo "Template $TEMP_VM_ID has been created with qemu-guest-agent."
echo "Remember to update terraform.tfvars with the new template_id!"
echo ""
