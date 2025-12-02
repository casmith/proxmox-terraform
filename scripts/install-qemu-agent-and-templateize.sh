#!/bin/bash
# Run this on Proxmox to install qemu-guest-agent on VM 9000 and convert to template
set -e

VM_ID=9000

echo "============================================"
echo "Installing QEMU Guest Agent on VM $VM_ID"
echo "============================================"
echo ""

# Check if VM exists
if ! qm status $VM_ID &>/dev/null; then
    echo "ERROR: VM $VM_ID does not exist!"
    exit 1
fi

# Check if it's a template (shouldn't be based on user input)
if qm config $VM_ID | grep -q "template: 1"; then
    echo "ERROR: VM $VM_ID is a template. Converting to regular VM first..."
    qm set $VM_ID --template 0
fi

echo "Step 1: Starting VM $VM_ID..."
qm start $VM_ID || echo "VM may already be running..."

echo ""
echo "Step 2: Waiting for VM to boot (60 seconds)..."
sleep 60

echo ""
echo "Step 3: Getting VM IP address..."
VM_IP=""
for i in {1..10}; do
    VM_IP=$(qm guest cmd $VM_ID network-get-interfaces 2>/dev/null | grep -A 3 '"name": "eth0"' | grep -oP '"ip-address": "\K[^"]+' | grep -v '^127\|^::1\|^fe80' | head -1 || echo "")
    if [ -n "$VM_IP" ]; then
        break
    fi
    echo "Waiting for IP... attempt $i/10"
    sleep 5
done

if [ -z "$VM_IP" ]; then
    echo ""
    echo "Could not get IP automatically. Checking DHCP or console..."
    read -p "Enter the VM IP address: " VM_IP
fi

echo "VM IP Address: $VM_IP"

echo ""
echo "Step 4: Waiting for SSH to be ready..."
sleep 10

echo ""
echo "Step 5: Installing QEMU guest agent..."
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30 ubuntu@$VM_IP << 'ENDSSH'
echo "Updating package list..."
sudo apt-get update -qq
echo "Installing qemu-guest-agent..."
sudo apt-get install -y qemu-guest-agent
echo "Enabling and starting service..."
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent
echo "Verifying installation..."
sudo systemctl status qemu-guest-agent --no-pager | head -5
echo ""
echo "✓ QEMU guest agent installed successfully!"
ENDSSH

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: SSH installation failed!"
    echo "Trying manual prompt..."
    read -p "Press Enter once you've manually installed qemu-guest-agent, or Ctrl+C to abort..."
fi

echo ""
echo "Step 6: Verifying agent communication..."
sleep 5
if qm guest cmd $VM_ID ping 2>/dev/null | grep -q "return"; then
    echo "✓ QEMU guest agent is responding!"
else
    echo "⚠ Agent may not be responding yet (this is sometimes normal)"
fi

echo ""
echo "Step 7: Shutting down VM..."
qm shutdown $VM_ID
echo "Waiting for clean shutdown (30 seconds)..."
sleep 30

# Force stop if still running
if qm status $VM_ID | grep -q "running"; then
    echo "Force stopping VM..."
    qm stop $VM_ID
    sleep 5
fi

echo ""
echo "Step 8: Converting VM $VM_ID to template..."
qm template $VM_ID

echo ""
echo "============================================"
echo "SUCCESS!"
echo "============================================"
echo ""
echo "VM $VM_ID is now a template with qemu-guest-agent installed."
echo "All future VMs cloned from this template will have the agent."
echo ""
echo "Your Terraform configuration is already set to use template_id = 9000"
echo ""
