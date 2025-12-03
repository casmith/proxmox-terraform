# Windows VMs Outputs
output "vm_details" {
  description = "Detailed information about Windows VMs"
  value       = try(module.windows_vms[0].vm_details, {})
}

output "vm_ips" {
  description = "IP addresses of Windows VMs"
  value       = try(module.windows_vms[0].vm_ips, [])
}
