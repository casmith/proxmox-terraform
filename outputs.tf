output "vm_id" {
  description = "The ID of the VM"
  value       = proxmox_virtual_environment_vm.ubuntu_vm.vm_id
}

output "vm_name" {
  description = "The name of the VM"
  value       = proxmox_virtual_environment_vm.ubuntu_vm.name
}

output "vm_ip" {
  description = "The IP address of the VM"
  value       = try(proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses[1][0], "Waiting for IP...")
}
