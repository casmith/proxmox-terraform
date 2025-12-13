# Main Terraform configuration
# This file orchestrates all OS-specific VM modules

# Ubuntu VMs Module
module "ubuntu" {
  source = "./ubuntu"

  # Shared configuration
  proxmox_node      = var.proxmox_node
  vm_storage        = var.vm_storage
  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  ssh_keys          = local.ssh_keys

  # Ubuntu-specific configuration (passed through from root variables)
  ubuntu_vm_count     = var.ubuntu_vm_count
  ubuntu_vm_name      = var.ubuntu_vm_name
  ubuntu_vm_tags      = var.ubuntu_vm_tags
  ubuntu_template_id  = var.ubuntu_template_id
  ubuntu_vm_cores     = var.ubuntu_vm_cores
  ubuntu_vm_memory    = var.ubuntu_vm_memory
  ubuntu_vm_disk_size = var.ubuntu_vm_disk_size
  ubuntu_vm_user      = var.ubuntu_vm_user
}

# Talos Linux VMs Module
module "talos" {
  source = "./talos"

  # Shared configuration
  proxmox_node      = var.proxmox_node
  vm_storage        = var.vm_storage
  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  ssh_keys          = local.ssh_keys

  # Talos-specific configuration (passed through from root variables)
  talos_vm_count     = var.talos_vm_count
  talos_vm_name      = var.talos_vm_name
  talos_vm_tags      = var.talos_vm_tags
  talos_template_id  = var.talos_template_id
  talos_vm_cores     = var.talos_vm_cores
  talos_vm_memory    = var.talos_vm_memory
  talos_vm_disk_size = var.talos_vm_disk_size
}

# Windows VMs Module (disabled by default)
module "windows" {
  source = "./windows"

  # Shared configuration
  proxmox_node      = var.proxmox_node
  vm_storage        = var.vm_storage
  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  ssh_keys          = local.ssh_keys

  # Windows-specific configuration (passed through from root variables)
  windows_vm_count     = var.windows_vm_count
  windows_vm_name      = var.windows_vm_name
  windows_vm_tags      = var.windows_vm_tags
  windows_template_id  = var.windows_template_id
  windows_vm_cores     = var.windows_vm_cores
  windows_vm_memory    = var.windows_vm_memory
  windows_vm_disk_size = var.windows_vm_disk_size
  windows_vm_user      = var.windows_vm_user
}

# FreeBSD VMs Module
module "freebsd" {
  source = "./freebsd"

  # Shared configuration
  proxmox_node      = var.proxmox_node
  vm_storage        = var.vm_storage
  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  ssh_keys          = local.ssh_keys

  # FreeBSD-specific configuration (passed through from root variables)
  freebsd_vm_count     = var.freebsd_vm_count
  freebsd_vm_name      = var.freebsd_vm_name
  freebsd_vm_tags      = var.freebsd_vm_tags
  freebsd_template_id  = var.freebsd_template_id
  freebsd_vm_cores     = var.freebsd_vm_cores
  freebsd_vm_memory    = var.freebsd_vm_memory
  freebsd_vm_disk_size = var.freebsd_vm_disk_size
  freebsd_vm_user      = var.freebsd_vm_user
}

# Talos Linux Sandbox VMs Module
# Talos Sandbox VMs on pve1 (1 VM)
module "talos_sandbox_pve1" {
  source = "./talos-sandbox"

  # Node-specific configuration
  proxmox_node      = "pve1"
  vm_storage        = "nfs-shared"  # Must use shared storage for cross-node template access
  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  ssh_keys          = local.ssh_keys

  # Talos Sandbox-specific configuration
  talos_vm_count         = 1  # 1 VM on pve1
  talos_vm_name          = "${var.talos_sandbox_vm_name}-pve1"
  talos_vm_tags          = var.talos_sandbox_vm_tags
  talos_template_id      = var.talos_sandbox_template_id
  talos_template_node    = "pve1"  # Template is located on pve1
  talos_vm_cores         = var.talos_sandbox_vm_cores
  talos_vm_memory        = var.talos_sandbox_vm_memory
  talos_vm_disk_size     = var.talos_sandbox_vm_disk_size
  talos_vm_mac_addresses = ["BC:24:11:51:59:8B"]  # Static MAC for DHCP reservation
}

# Talos Sandbox VMs on pve2 (2 VMs)
module "talos_sandbox_pve2" {
  source = "./talos-sandbox"

  # Node-specific configuration
  proxmox_node      = "pve2"
  vm_storage        = "nfs-shared"  # Must use shared storage for cross-node cloning
  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  ssh_keys          = local.ssh_keys

  # Talos Sandbox-specific configuration
  talos_vm_count         = 2  # 2 VMs on pve2
  talos_vm_name          = "${var.talos_sandbox_vm_name}-pve2"
  talos_vm_tags          = var.talos_sandbox_vm_tags
  talos_template_id      = var.talos_sandbox_template_id
  talos_template_node    = "pve1"  # Template is located on pve1
  talos_vm_cores         = var.talos_sandbox_vm_cores
  talos_vm_memory        = var.talos_sandbox_vm_memory
  talos_vm_disk_size     = var.talos_sandbox_vm_disk_size
  talos_vm_mac_addresses = ["BC:24:11:42:4E:F3", "BC:24:11:B2:0B:F7"]  # Static MACs for DHCP reservations
}
