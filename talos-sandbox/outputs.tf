# Talos Sandbox VMs Outputs
output "vm_details" {
  description = "Detailed information about Talos Sandbox VMs"
  value       = try(module.talos_vms[0].vm_details, {})
}

output "vm_ips" {
  description = "IP addresses of Talos Sandbox VMs"
  value       = try(module.talos_vms[0].vm_ips, [])
}
