#!/bin/bash
set -e

# Export S3 credentials for Terraform
export AWS_ACCESS_KEY_ID=$(mise exec -- sops --decrypt secrets.yaml | grep 's3_access_key:' | awk '{print $2}')
export AWS_SECRET_ACCESS_KEY=$(mise exec -- sops --decrypt secrets.yaml | grep 's3_secret_key:' | awk '{print $2}')

echo "Starting Terraform import process..."
echo "This will import all existing VMs into the Terraform state"
echo ""

# pve1 VMs
echo "=== Importing pve1 VMs ==="
mise exec -- terraform import 'module.pve1.module.ubuntu_vms[0].proxmox_virtual_environment_vm.vm[0]' pve1/113
mise exec -- terraform import 'module.pve1.module.ubuntu_vms[0].proxmox_virtual_environment_vm.vm[1]' pve1/114
mise exec -- terraform import 'module.pve1.module.archlinux_vms[0].proxmox_virtual_environment_vm.vm[0]' pve1/111
mise exec -- terraform import 'module.pve1.module.talos_vms[0].proxmox_virtual_environment_vm.vm[0]' pve1/102
mise exec -- terraform import 'module.pve1.module.talos_sandbox_vms[0].proxmox_virtual_environment_vm.vm[0]' pve1/100
mise exec -- terraform import 'module.pve1.module.talos_obs_vms[0].proxmox_virtual_environment_vm.vm[0]' pve1/117

echo ""
echo "=== Importing pve2 VMs ==="
mise exec -- terraform import 'module.pve2.module.ubuntu_vms[0].proxmox_virtual_environment_vm.vm[0]' pve2/109
mise exec -- terraform import 'module.pve2.module.ubuntu_highmem_vms[0].proxmox_virtual_environment_vm.vm[0]' pve2/106
mise exec -- terraform import 'module.pve2.module.talos_vms[0].proxmox_virtual_environment_vm.vm[0]' pve2/107
mise exec -- terraform import 'module.pve2.module.talos_sandbox_vms[0].proxmox_virtual_environment_vm.vm[0]' pve2/103
mise exec -- terraform import 'module.pve2.module.talos_sandbox_vms[0].proxmox_virtual_environment_vm.vm[1]' pve2/101
mise exec -- terraform import 'module.pve2.module.talos_obs_vms[0].proxmox_virtual_environment_vm.vm[0]' pve2/116

echo ""
echo "=== Importing pve3 VMs ==="
mise exec -- terraform import 'module.pve3.module.ubuntu_vms[0].proxmox_virtual_environment_vm.vm[0]' pve3/105
mise exec -- terraform import 'module.pve3.module.ubuntu_highmem_vms[0].proxmox_virtual_environment_vm.vm[0]' pve3/108
mise exec -- terraform import 'module.pve3.module.talos_obs_vms[0].proxmox_virtual_environment_vm.vm[0]' pve3/115

echo ""
echo "=== Importing pve4 VMs ==="
mise exec -- terraform import 'module.pve4.module.ubuntu_vms[0].proxmox_virtual_environment_vm.vm[0]' pve4/112
mise exec -- terraform import 'module.pve4.module.ubuntu_highmem_vms[0].proxmox_virtual_environment_vm.vm[0]' pve4/110

echo ""
echo "==================================================================="
echo "Import complete!"
echo ""
echo "NOTE: talos-vm-02 on pve1 (VMID 104) was NOT imported"
echo "      It will be destroyed when you run 'terraform apply'"
echo ""
echo "Next steps:"
echo "1. Run: mise run tfplan"
echo "2. Review the plan - should show:"
echo "   - talos-vm-02 will be destroyed (expected)"
echo "   - Memory updates already match (no changes)"
echo "3. Run: mise run tfapply to finalize"
echo "==================================================================="
