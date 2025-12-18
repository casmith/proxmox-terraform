# pve2 Node Outputs

# ============================================================================
# Ubuntu VM Outputs
# ============================================================================

output "ubuntu_vm_details" {
  description = "Detailed information about Ubuntu VMs on pve2"
  value       = try(module.ubuntu_vms[0].vm_details, {})
}

output "ubuntu_vm_ips" {
  description = "IP addresses of Ubuntu VMs on pve2"
  value       = try(module.ubuntu_vms[0].vm_ips, [])
}

# ============================================================================
# Ubuntu High-Memory VM Outputs
# ============================================================================

output "ubuntu_highmem_vm_details" {
  description = "Detailed information about high-memory Ubuntu VMs on pve2"
  value       = try(module.ubuntu_highmem_vms[0].vm_details, {})
}

output "ubuntu_highmem_vm_ips" {
  description = "IP addresses of high-memory Ubuntu VMs on pve2"
  value       = try(module.ubuntu_highmem_vms[0].vm_ips, [])
}

# ============================================================================
# Talos VM Outputs
# ============================================================================

output "talos_vm_details" {
  description = "Detailed information about Talos VMs on pve2"
  value       = try(module.talos_vms[0].vm_details, {})
}

output "talos_vm_ips" {
  description = "IP addresses of Talos VMs on pve2"
  value       = try(module.talos_vms[0].vm_ips, [])
}

# ============================================================================
# Talos Sandbox VM Outputs
# ============================================================================

output "talos_sandbox_vm_details" {
  description = "Detailed information about Talos Sandbox VMs on pve2"
  value       = try(module.talos_sandbox_vms[0].vm_details, {})
}

output "talos_sandbox_vm_ips" {
  description = "IP addresses of Talos Sandbox VMs on pve2"
  value       = try(module.talos_sandbox_vms[0].vm_ips, [])
}

# ============================================================================
# Windows VM Outputs
# ============================================================================



# ============================================================================
# FreeBSD VM Outputs
# ============================================================================



# ============================================================================
# Combined Node Outputs
# ============================================================================

output "all_vms" {
  description = "All VMs on pve2 grouped by type"
  value = {
    ubuntu         = try(module.ubuntu_vms[0].vm_details, {})
    ubuntu_highmem = try(module.ubuntu_highmem_vms[0].vm_details, {})
    talos          = try(module.talos_vms[0].vm_details, {})
    talos_sandbox  = try(module.talos_sandbox_vms[0].vm_details, {})
  }
}
