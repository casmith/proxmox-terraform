#!/bin/bash
# Run this ON PROXMOX SERVER to clean up VMs and templates
set -e

echo "============================================"
echo "Cleaning Up Proxmox VMs and Templates"
echo "============================================"
echo ""

# List all VMs
echo "Current VMs and Templates:"
qm list
echo ""

read -p "Continue with cleanup? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Step 1: Destroying Terraform-managed VM (ID 105)..."
if qm status 105 &>/dev/null; then
    qm stop 105 || true
    sleep 3
    qm destroy 105
    echo "✓ VM 105 destroyed"
else
    echo "VM 105 does not exist (already clean)"
fi

echo ""
echo "Step 2: Removing template/VM 9000..."
if qm status 9000 &>/dev/null; then
    # If it's a template, convert it first
    qm set 9000 --template 0 2>/dev/null || true
    qm stop 9000 2>/dev/null || true
    sleep 3
    qm destroy 9000
    echo "✓ VM/Template 9000 destroyed"
else
    echo "VM 9000 does not exist (already clean)"
fi

echo ""
echo "Step 3: Cleaning up any cloud-init ISOs..."
rm -f /tmp/noble-server-cloudimg-amd64.img
echo "✓ Temporary files cleaned"

echo ""
echo "============================================"
echo "Cleanup Complete!"
echo "============================================"
echo ""
echo "Proxmox is now clean. Next steps:"
echo "1. Create a new template with qemu-guest-agent pre-installed"
echo "2. Initialize Terraform with clean state"
echo ""
