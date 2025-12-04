# FreeBSD VMs Outputs
output "vm_details" {
  description = "Detailed information about FreeBSD VMs"
  value       = try(module.freebsd_vms[0].vm_details, {})
}

output "vm_ips" {
  description = "IP addresses of FreeBSD VMs"
  value       = try(module.freebsd_vms[0].vm_ips, [])
}
