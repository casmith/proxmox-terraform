# Ubuntu VMs Outputs
output "ubuntu_vm_details" {
  description = "Detailed information about Ubuntu VMs"
  value       = try(module.ubuntu_vms[0].vm_details, {})
}

output "ubuntu_vm_ips" {
  description = "IP addresses of Ubuntu VMs"
  value       = try(module.ubuntu_vms[0].vm_ips, [])
}

# Talos VMs Outputs
output "talos_vm_details" {
  description = "Detailed information about Talos VMs"
  value       = try(module.talos_vms[0].vm_details, {})
}

output "talos_vm_ips" {
  description = "IP addresses of Talos VMs"
  value       = try(module.talos_vms[0].vm_ips, [])
}

# Combined outputs
output "all_vms" {
  description = "All VM details grouped by type"
  value = {
    ubuntu = try(module.ubuntu_vms[0].vm_details, {})
    talos  = try(module.talos_vms[0].vm_details, {})
  }
}
