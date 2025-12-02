#!/bin/bash
# Run this script ON YOUR PROXMOX SERVER to add qemu-guest-agent to the template
set -e

TEMPLATE_ID=${1:-9000}
TEMPLATE_NAME="ubuntu-2404-cloudinit-template"

echo "============================================"
echo "Adding QEMU Guest Agent to Template"
echo "============================================"
echo ""
echo "Template ID: $TEMPLATE_ID"
echo ""

# Verify it's a template
if ! qm config $TEMPLATE_ID | grep -q "template: 1"; then
    echo "ERROR: VM $TEMPLATE_ID is not a template!"
    exit 1
fi

echo "Step 1: Converting template to regular VM..."
qm set $TEMPLATE_ID --template 0

echo ""
echo "Step 2: Starting the VM..."
qm start $TEMPLATE_ID

echo ""
echo "Step 3: Waiting for VM to boot and get IP address (60 seconds)..."
sleep 60

echo ""
echo "Step 4: Getting VM IP address..."
VM_IP=$(qm guest cmd $TEMPLATE_ID network-get-interfaces 2>/dev/null | grep -A 3 '"name": "eth0"' | grep -oP '"ip-address": "\K[^"]+' | grep -v '^127\|^::1' | head -1 || echo "")

if [ -z "$VM_IP" ]; then
    echo "WARNING: Could not get IP automatically. Checking for any IP..."
    VM_IP=$(qm guest cmd $TEMPLATE_ID network-get-interfaces 2>/dev/null | grep -oP '"ip-address": "\K[^"]+' | grep -v '^127\|^::1\|^fe80' | head -1 || echo "")
fi

if [ -z "$VM_IP" ]; then
    echo ""
    echo "Could not determine VM IP automatically."
    echo "Please find the IP address manually from the Proxmox console or DHCP server."
    read -p "Enter the VM IP address: " VM_IP
fi

echo "VM IP Address: $VM_IP"

echo ""
echo "Step 5: Installing QEMU guest agent via SSH..."
echo "This will prompt for the ubuntu user password if SSH keys aren't set up."
echo "Default cloud-init images don't have a password - using SSH keys from your host."

# Try to install using SSH
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@$VM_IP << 'ENDSSH'
sudo apt-get update
sudo apt-get install -y qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent
echo "QEMU guest agent installed and started!"
ENDSSH

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Failed to install via SSH."
    echo "Alternative: You can install manually:"
    echo "  1. Access the VM console in Proxmox"
    echo "  2. Login as ubuntu (you may need to set a password first)"
    echo "  3. Run: sudo apt update && sudo apt install -y qemu-guest-agent"
    echo "  4. Run: sudo systemctl enable --now qemu-guest-agent"
    echo ""
    read -p "Press Enter once you've completed manual installation, or Ctrl+C to abort..."
fi

echo ""
echo "Step 6: Waiting for agent to be active..."
sleep 5

# Verify agent is running
if qm guest cmd $TEMPLATE_ID ping 2>/dev/null | grep -q "return"; then
    echo "✓ QEMU guest agent is active!"
else
    echo "WARNING: Agent might not be responding yet. Continuing anyway..."
fi

echo ""
echo "Step 7: Shutting down VM gracefully..."
qm shutdown $TEMPLATE_ID
sleep 20

# Force stop if still running
if qm status $TEMPLATE_ID | grep -q "running"; then
    echo "Force stopping VM..."
    qm stop $TEMPLATE_ID
    sleep 5
fi

echo ""
echo "Step 8: Converting back to template..."
qm template $TEMPLATE_ID

echo ""
echo "============================================"
echo "SUCCESS!"
echo "============================================"
echo ""
echo "Template $TEMPLATE_ID has been updated with qemu-guest-agent."
echo "All future VMs cloned from this template will have the agent pre-installed."
echo ""
