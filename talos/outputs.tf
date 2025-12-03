# Talos VMs Outputs
output "vm_details" {
  description = "Detailed information about Talos VMs"
  value       = try(module.talos_vms[0].vm_details, {})
}

output "vm_ips" {
  description = "IP addresses of Talos VMs"
  value       = try(module.talos_vms[0].vm_ips, [])
}
