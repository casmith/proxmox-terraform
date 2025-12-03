output "vm_ids" {
  description = "The IDs of the VMs"
  value       = proxmox_virtual_environment_vm.ubuntu_vm[*].vm_id
}

output "vm_names" {
  description = "The names of the VMs"
  value       = proxmox_virtual_environment_vm.ubuntu_vm[*].name
}

output "vm_ips" {
  description = "The IP addresses of the VMs"
  value       = [for vm in proxmox_virtual_environment_vm.ubuntu_vm : try(vm.ipv4_addresses[1][0], "Waiting for IP...")]
}

output "vm_details" {
  description = "Detailed information about all VMs"
  value = {
    for idx, vm in proxmox_virtual_environment_vm.ubuntu_vm : vm.name => {
      id = vm.vm_id
      ip = try(vm.ipv4_addresses[1][0], "Waiting for IP...")
    }
  }
}
