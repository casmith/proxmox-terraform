#!/bin/bash
# Run on Proxmox to find cloud-init templates
echo "Looking for cloud-init templates..."
echo ""
qm list | grep -i template || qm list | grep -i ubuntu || qm list
