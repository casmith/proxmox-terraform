# Ubuntu VMs Outputs
output "ubuntu_vm_details" {
  description = "Detailed information about Ubuntu VMs"
  value       = module.ubuntu.vm_details
}

output "ubuntu_vm_ips" {
  description = "IP addresses of Ubuntu VMs"
  value       = module.ubuntu.vm_ips
}

# Talos VMs Outputs
output "talos_vm_details" {
  description = "Detailed information about Talos VMs"
  value       = module.talos.vm_details
}

output "talos_vm_ips" {
  description = "IP addresses of Talos VMs"
  value       = module.talos.vm_ips
}

# Windows VMs Outputs
output "windows_vm_details" {
  description = "Detailed information about Windows VMs"
  value       = module.windows.vm_details
}

output "windows_vm_ips" {
  description = "IP addresses of Windows VMs"
  value       = module.windows.vm_ips
}

# FreeBSD VMs Outputs
output "freebsd_vm_details" {
  description = "Detailed information about FreeBSD VMs"
  value       = module.freebsd.vm_details
}

output "freebsd_vm_ips" {
  description = "IP addresses of FreeBSD VMs"
  value       = module.freebsd.vm_ips
}

# Combined outputs - all VMs grouped by type
output "all_vms" {
  description = "All VM details grouped by type"
  value = {
    ubuntu  = module.ubuntu.vm_details
    talos   = module.talos.vm_details
    windows = module.windows.vm_details
    freebsd = module.freebsd.vm_details
  }
}
