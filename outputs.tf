# Root Outputs File
# Combines outputs from all node modules

# ============================================================================
# pve1 Outputs
# ============================================================================

output "pve1_ubuntu_vm_details" {
  description = "Ubuntu VMs on pve1"
  value       = module.pve1.ubuntu_vm_details
}

output "pve1_ubuntu_vm_ips" {
  description = "Ubuntu VM IPs on pve1"
  value       = module.pve1.ubuntu_vm_ips
}

output "pve1_talos_vm_details" {
  description = "Talos VMs on pve1"
  value       = module.pve1.talos_vm_details
}

output "pve1_talos_vm_ips" {
  description = "Talos VM IPs on pve1"
  value       = module.pve1.talos_vm_ips
}

output "pve1_talos_sandbox_vm_details" {
  description = "Talos Sandbox VMs on pve1"
  value       = module.pve1.talos_sandbox_vm_details
}

output "pve1_talos_sandbox_vm_ips" {
  description = "Talos Sandbox VM IPs on pve1"
  value       = module.pve1.talos_sandbox_vm_ips
}

output "pve1_all_vms" {
  description = "All VMs on pve1"
  value       = module.pve1.all_vms
}

# ============================================================================
# pve2 Outputs
# ============================================================================

output "pve2_ubuntu_vm_details" {
  description = "Ubuntu VMs on pve2"
  value       = module.pve2.ubuntu_vm_details
}

output "pve2_ubuntu_vm_ips" {
  description = "Ubuntu VM IPs on pve2"
  value       = module.pve2.ubuntu_vm_ips
}

output "pve2_talos_vm_details" {
  description = "Talos VMs on pve2"
  value       = module.pve2.talos_vm_details
}

output "pve2_talos_vm_ips" {
  description = "Talos VM IPs on pve2"
  value       = module.pve2.talos_vm_ips
}

output "pve2_talos_sandbox_vm_details" {
  description = "Talos Sandbox VMs on pve2"
  value       = module.pve2.talos_sandbox_vm_details
}

output "pve2_talos_sandbox_vm_ips" {
  description = "Talos Sandbox VM IPs on pve2"
  value       = module.pve2.talos_sandbox_vm_ips
}

output "pve2_all_vms" {
  description = "All VMs on pve2"
  value       = module.pve2.all_vms
}

# ============================================================================
# pve3 Outputs
# ============================================================================

output "pve3_ubuntu_vm_details" {
  description = "Ubuntu VMs on pve3"
  value       = module.pve3.ubuntu_vm_details
}

output "pve3_ubuntu_vm_ips" {
  description = "Ubuntu VM IPs on pve3"
  value       = module.pve3.ubuntu_vm_ips
}

output "pve3_talos_vm_details" {
  description = "Talos VMs on pve3"
  value       = module.pve3.talos_vm_details
}

output "pve3_talos_vm_ips" {
  description = "Talos VM IPs on pve3"
  value       = module.pve3.talos_vm_ips
}

output "pve3_talos_sandbox_vm_details" {
  description = "Talos Sandbox VMs on pve3"
  value       = module.pve3.talos_sandbox_vm_details
}

output "pve3_talos_sandbox_vm_ips" {
  description = "Talos Sandbox VM IPs on pve3"
  value       = module.pve3.talos_sandbox_vm_ips
}

output "pve3_all_vms" {
  description = "All VMs on pve3"
  value       = module.pve3.all_vms
}

# ============================================================================
# pve4 Outputs
# ============================================================================

output "pve4_ubuntu_vm_details" {
  description = "Ubuntu VMs on pve4"
  value       = module.pve4.ubuntu_vm_details
}

output "pve4_ubuntu_vm_ips" {
  description = "Ubuntu VM IPs on pve4"
  value       = module.pve4.ubuntu_vm_ips
}

output "pve4_talos_vm_details" {
  description = "Talos VMs on pve4"
  value       = module.pve4.talos_vm_details
}

output "pve4_talos_vm_ips" {
  description = "Talos VM IPs on pve4"
  value       = module.pve4.talos_vm_ips
}

output "pve4_talos_sandbox_vm_details" {
  description = "Talos Sandbox VMs on pve4"
  value       = module.pve4.talos_sandbox_vm_details
}

output "pve4_talos_sandbox_vm_ips" {
  description = "Talos Sandbox VM IPs on pve4"
  value       = module.pve4.talos_sandbox_vm_ips
}

output "pve4_all_vms" {
  description = "All VMs on pve4"
  value       = module.pve4.all_vms
}

# ============================================================================
# pve5 Outputs
# ============================================================================

output "pve5_ubuntu_vm_details" {
  description = "Ubuntu VMs on pve5"
  value       = module.pve5.ubuntu_vm_details
}

output "pve5_ubuntu_vm_ips" {
  description = "Ubuntu VM IPs on pve5"
  value       = module.pve5.ubuntu_vm_ips
}

output "pve5_talos_vm_details" {
  description = "Talos VMs on pve5"
  value       = module.pve5.talos_vm_details
}

output "pve5_talos_vm_ips" {
  description = "Talos VM IPs on pve5"
  value       = module.pve5.talos_vm_ips
}

output "pve5_talos_sandbox_vm_details" {
  description = "Talos Sandbox VMs on pve5"
  value       = module.pve5.talos_sandbox_vm_details
}

output "pve5_talos_sandbox_vm_ips" {
  description = "Talos Sandbox VM IPs on pve5"
  value       = module.pve5.talos_sandbox_vm_ips
}

output "pve5_talos_obs_vm_details" {
  description = "Talos Obs VMs on pve5"
  value       = module.pve5.talos_obs_vm_details
}

output "pve5_talos_obs_vm_ips" {
  description = "Talos Obs VM IPs on pve5"
  value       = module.pve5.talos_obs_vm_ips
}

output "pve5_all_vms" {
  description = "All VMs on pve5"
  value       = module.pve5.all_vms
}

# ============================================================================
# Combined Cluster Outputs
# ============================================================================

output "all_vms_by_node" {
  description = "All VMs grouped by node"
  value = {
    pve1 = module.pve1.all_vms
    pve2 = module.pve2.all_vms
    pve3 = module.pve3.all_vms
    pve4 = module.pve4.all_vms
    pve5 = module.pve5.all_vms
  }
}

output "all_ubuntu_vms" {
  description = "All Ubuntu VMs across all nodes"
  value = merge(
    module.pve1.ubuntu_vm_details,
    module.pve2.ubuntu_vm_details,
    module.pve3.ubuntu_vm_details,
    module.pve4.ubuntu_vm_details,
    module.pve5.ubuntu_vm_details
  )
}

output "all_talos_vms" {
  description = "All Talos VMs across all nodes"
  value = merge(
    module.pve1.talos_vm_details,
    module.pve2.talos_vm_details,
    module.pve3.talos_vm_details,
    module.pve4.talos_vm_details,
    module.pve5.talos_vm_details
  )
}

output "all_talos_sandbox_vms" {
  description = "All Talos Sandbox VMs across all nodes"
  value = merge(
    module.pve1.talos_sandbox_vm_details,
    module.pve2.talos_sandbox_vm_details,
    module.pve3.talos_sandbox_vm_details,
    module.pve4.talos_sandbox_vm_details,
    module.pve5.talos_sandbox_vm_details
  )
}

output "all_vm_ips" {
  description = "All VM IPs across all nodes"
  value = concat(
    module.pve1.ubuntu_vm_ips,
    module.pve1.talos_vm_ips,
    module.pve1.talos_sandbox_vm_ips,
    module.pve2.ubuntu_vm_ips,
    module.pve2.talos_vm_ips,
    module.pve2.talos_sandbox_vm_ips,
    module.pve3.ubuntu_vm_ips,
    module.pve3.talos_vm_ips,
    module.pve3.talos_sandbox_vm_ips,
    module.pve4.ubuntu_vm_ips,
    module.pve4.talos_vm_ips,
    module.pve4.talos_sandbox_vm_ips,
    module.pve5.ubuntu_vm_ips,
    module.pve5.talos_vm_ips,
    module.pve5.talos_sandbox_vm_ips
  )
}
