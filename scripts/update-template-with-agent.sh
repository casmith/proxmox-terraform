#!/bin/bash
# Run this script ON YOUR PROXMOX SERVER to update the template
# with qemu-guest-agent pre-installed

set -e

TEMPLATE_ID=${1:-9000}

echo "==================================="
echo "Installing QEMU Guest Agent in Template"
echo "==================================="
echo ""
echo "Template ID: $TEMPLATE_ID"
echo ""

# Check if this is a template
if ! qm config $TEMPLATE_ID | grep -q "template: 1"; then
    echo "Error: VM $TEMPLATE_ID is not a template!"
    exit 1
fi

echo "Step 1: Converting template to VM temporarily..."
qm template $TEMPLATE_ID --delete

echo ""
echo "Step 2: Starting VM..."
qm start $TEMPLATE_ID

echo ""
echo "Step 3: Waiting for VM to boot (30 seconds)..."
sleep 30

echo ""
echo "Step 4: Installing qemu-guest-agent via cloud-init..."
# Note: This requires the VM to have network access and cloud-init working
# You may need to wait and check the VM console to see when it's ready

echo ""
echo "MANUAL STEP REQUIRED:"
echo "1. SSH into the VM: ssh ubuntu@<VM_IP>"
echo "2. Run: sudo apt update && sudo apt install -y qemu-guest-agent"
echo "3. Run: sudo systemctl enable --now qemu-guest-agent"
echo "4. Exit the SSH session"
echo ""
read -p "Press Enter once you've completed the manual installation..."

echo ""
echo "Step 5: Shutting down VM..."
qm shutdown $TEMPLATE_ID
sleep 10

echo ""
echo "Step 6: Converting back to template..."
qm template $TEMPLATE_ID

echo ""
echo "==================================="
echo "SUCCESS!"
echo "==================================="
echo ""
echo "Template $TEMPLATE_ID now has qemu-guest-agent installed."
echo "New VMs cloned from this template will have the agent pre-installed."
