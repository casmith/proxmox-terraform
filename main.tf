# Main Terraform Configuration
# Node-based architecture - each node module contains all VMs for that node

# ============================================================================
# pve1 Node Module
# ============================================================================

module "pve1" {
  source = "./nodes/pve1"

  # Shared configuration
  proxmox_node      = "pve1"
  vm_storage        = var.vm_storage
  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  ssh_keys          = local.ssh_keys

  # Template IDs (node-specific, defined in nodes/pve1/terraform.tfvars)
  ubuntu_template_id  = var.pve1_ubuntu_template_id
  talos_template_id   = var.pve1_talos_template_id
  windows_template_id = var.pve1_windows_template_id
  freebsd_template_id = var.pve1_freebsd_template_id

  # Ubuntu VM configuration
  ubuntu_vm_count         = var.pve1_ubuntu_vm_count
  ubuntu_vm_name          = var.pve1_ubuntu_vm_name
  ubuntu_vm_cores         = var.pve1_ubuntu_vm_cores
  ubuntu_vm_memory        = var.pve1_ubuntu_vm_memory
  ubuntu_vm_disk_size     = var.pve1_ubuntu_vm_disk_size
  ubuntu_vm_user          = var.pve1_ubuntu_vm_user
  ubuntu_vm_tags          = var.pve1_ubuntu_vm_tags
  ubuntu_vm_mac_addresses = var.pve1_ubuntu_vm_mac_addresses

  # Talos VM configuration
  talos_vm_count         = var.pve1_talos_vm_count
  talos_vm_name          = var.pve1_talos_vm_name
  talos_vm_cores         = var.pve1_talos_vm_cores
  talos_vm_memory        = var.pve1_talos_vm_memory
  talos_vm_disk_size     = var.pve1_talos_vm_disk_size
  talos_vm_tags          = var.pve1_talos_vm_tags
  talos_vm_mac_addresses = var.pve1_talos_vm_mac_addresses

  # Talos Sandbox VM configuration
  talos_sandbox_vm_count         = var.pve1_talos_sandbox_vm_count
  talos_sandbox_vm_name          = var.pve1_talos_sandbox_vm_name
  talos_sandbox_vm_cores         = var.pve1_talos_sandbox_vm_cores
  talos_sandbox_vm_memory        = var.pve1_talos_sandbox_vm_memory
  talos_sandbox_vm_disk_size     = var.pve1_talos_sandbox_vm_disk_size
  talos_sandbox_vm_mac_addresses = var.pve1_talos_sandbox_vm_mac_addresses
  talos_sandbox_vm_tags          = var.pve1_talos_sandbox_vm_tags

  # Windows VM configuration
  windows_vm_count     = var.pve1_windows_vm_count
  windows_vm_name      = var.pve1_windows_vm_name
  windows_vm_cores     = var.pve1_windows_vm_cores
  windows_vm_memory    = var.pve1_windows_vm_memory
  windows_vm_disk_size = var.pve1_windows_vm_disk_size
  windows_vm_user      = var.pve1_windows_vm_user
  windows_vm_tags      = var.pve1_windows_vm_tags

  # FreeBSD VM configuration
  freebsd_vm_count     = var.pve1_freebsd_vm_count
  freebsd_vm_name      = var.pve1_freebsd_vm_name
  freebsd_vm_cores     = var.pve1_freebsd_vm_cores
  freebsd_vm_memory    = var.pve1_freebsd_vm_memory
  freebsd_vm_disk_size = var.pve1_freebsd_vm_disk_size
  freebsd_vm_user      = var.pve1_freebsd_vm_user
  freebsd_vm_tags      = var.pve1_freebsd_vm_tags
}

# ============================================================================
# pve2 Node Module
# ============================================================================

module "pve2" {
  source = "./nodes/pve2"

  # Shared configuration
  proxmox_node      = "pve2"
  vm_storage        = var.vm_storage
  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  ssh_keys          = local.ssh_keys

  # Template IDs (node-specific, defined in nodes/pve2/terraform.tfvars)
  ubuntu_template_id  = var.pve2_ubuntu_template_id
  talos_template_id   = var.pve2_talos_template_id
  windows_template_id = var.pve2_windows_template_id
  freebsd_template_id = var.pve2_freebsd_template_id

  # Ubuntu VM configuration
  ubuntu_vm_count         = var.pve2_ubuntu_vm_count
  ubuntu_vm_name          = var.pve2_ubuntu_vm_name
  ubuntu_vm_cores         = var.pve2_ubuntu_vm_cores
  ubuntu_vm_memory        = var.pve2_ubuntu_vm_memory
  ubuntu_vm_disk_size     = var.pve2_ubuntu_vm_disk_size
  ubuntu_vm_user          = var.pve2_ubuntu_vm_user
  ubuntu_vm_tags          = var.pve2_ubuntu_vm_tags
  ubuntu_vm_mac_addresses = var.pve2_ubuntu_vm_mac_addresses

  # Ubuntu High-Memory VM configuration
  ubuntu_highmem_vm_count         = var.pve2_ubuntu_highmem_vm_count
  ubuntu_highmem_vm_name          = var.pve2_ubuntu_highmem_vm_name
  ubuntu_highmem_vm_cores         = var.pve2_ubuntu_highmem_vm_cores
  ubuntu_highmem_vm_memory        = var.pve2_ubuntu_highmem_vm_memory
  ubuntu_highmem_vm_disk_size     = var.pve2_ubuntu_highmem_vm_disk_size
  ubuntu_highmem_vm_mac_addresses = var.pve2_ubuntu_highmem_vm_mac_addresses

  # Talos VM configuration
  talos_vm_count         = var.pve2_talos_vm_count
  talos_vm_name          = var.pve2_talos_vm_name
  talos_vm_cores         = var.pve2_talos_vm_cores
  talos_vm_memory        = var.pve2_talos_vm_memory
  talos_vm_disk_size     = var.pve2_talos_vm_disk_size
  talos_vm_tags          = var.pve2_talos_vm_tags
  talos_vm_mac_addresses = var.pve2_talos_vm_mac_addresses

  # Talos Sandbox VM configuration
  talos_sandbox_vm_count         = var.pve2_talos_sandbox_vm_count
  talos_sandbox_vm_name          = var.pve2_talos_sandbox_vm_name
  talos_sandbox_vm_cores         = var.pve2_talos_sandbox_vm_cores
  talos_sandbox_vm_memory        = var.pve2_talos_sandbox_vm_memory
  talos_sandbox_vm_disk_size     = var.pve2_talos_sandbox_vm_disk_size
  talos_sandbox_vm_mac_addresses = var.pve2_talos_sandbox_vm_mac_addresses
  talos_sandbox_vm_tags          = var.pve2_talos_sandbox_vm_tags

  # Windows VM configuration
  windows_vm_count     = var.pve2_windows_vm_count
  windows_vm_name      = var.pve2_windows_vm_name
  windows_vm_cores     = var.pve2_windows_vm_cores
  windows_vm_memory    = var.pve2_windows_vm_memory
  windows_vm_disk_size = var.pve2_windows_vm_disk_size
  windows_vm_user      = var.pve2_windows_vm_user
  windows_vm_tags      = var.pve2_windows_vm_tags

  # FreeBSD VM configuration
  freebsd_vm_count     = var.pve2_freebsd_vm_count
  freebsd_vm_name      = var.pve2_freebsd_vm_name
  freebsd_vm_cores     = var.pve2_freebsd_vm_cores
  freebsd_vm_memory    = var.pve2_freebsd_vm_memory
  freebsd_vm_disk_size = var.pve2_freebsd_vm_disk_size
  freebsd_vm_user      = var.pve2_freebsd_vm_user
  freebsd_vm_tags      = var.pve2_freebsd_vm_tags
}
