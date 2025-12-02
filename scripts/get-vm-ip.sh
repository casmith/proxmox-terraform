#!/bin/bash
# Get VM IP address from Proxmox
# Run this on your Proxmox server or via SSH

VM_ID=105

echo "Getting IP address for VM $VM_ID..."
ssh root@192.168.10.11 "qm guest cmd $VM_ID network-get-interfaces" | grep -A 3 '"name": "eth0"' | grep -oP '"ip-address": "\K[^"]+' | grep -v '^127\|^::1' | head -1
