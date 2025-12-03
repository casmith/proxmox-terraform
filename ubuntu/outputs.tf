# Ubuntu VMs Outputs
output "vm_details" {
  description = "Detailed information about Ubuntu VMs"
  value       = try(module.ubuntu_vms[0].vm_details, {})
}

output "vm_ips" {
  description = "IP addresses of Ubuntu VMs"
  value       = try(module.ubuntu_vms[0].vm_ips, [])
}
