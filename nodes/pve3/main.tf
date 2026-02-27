# pve3 Node Module
# All VMs deployed to pve3

# ============================================================================
# Ubuntu VMs
# ============================================================================

module "ubuntu_vms" {
  source = "../../modules/proxmox-vm"

  count = var.ubuntu_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.ubuntu_vm_count
  vm_name      = var.ubuntu_vm_name
  vm_tags      = var.ubuntu_vm_tags

  template_id   = var.ubuntu_template_id
  template_node = null # Template is on same node

  vm_cores     = var.ubuntu_vm_cores
  vm_memory    = var.ubuntu_vm_memory
  vm_disk_size = var.ubuntu_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  vm_mac_addresses  = var.ubuntu_vm_mac_addresses

  vm_user  = var.ubuntu_vm_user
  ssh_keys = var.ssh_keys

  cloud_init_packages = ["qemu-guest-agent"]
  enable_qemu_agent   = true
}

# ============================================================================
# Ubuntu High-Memory VMs
# ============================================================================

module "ubuntu_highmem_vms" {
  source = "../../modules/proxmox-vm"

  count = var.ubuntu_highmem_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.ubuntu_highmem_vm_count
  vm_name      = var.ubuntu_highmem_vm_name
  vm_tags      = var.ubuntu_vm_tags

  template_id   = var.ubuntu_template_id
  template_node = null # Template is on same node

  vm_cores     = var.ubuntu_highmem_vm_cores
  vm_memory    = var.ubuntu_highmem_vm_memory
  vm_disk_size = var.ubuntu_highmem_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  vm_mac_addresses  = var.ubuntu_highmem_vm_mac_addresses

  vm_user  = var.ubuntu_vm_user
  ssh_keys = var.ssh_keys

  cloud_init_packages = ["qemu-guest-agent"]
  enable_qemu_agent   = true
}

# ============================================================================
# Talos VMs
# ============================================================================

module "talos_vms" {
  source = "../../modules/proxmox-vm"

  count = var.talos_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.talos_vm_count
  vm_name      = var.talos_vm_name
  vm_tags      = var.talos_vm_tags

  template_id   = var.talos_template_id
  template_node = null # Template is on same node

  vm_cores     = var.talos_vm_cores
  vm_memory    = var.talos_vm_memory
  vm_disk_size = var.talos_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  vm_mac_addresses  = var.talos_vm_mac_addresses

  vm_user  = "talos"
  ssh_keys = var.ssh_keys

  use_cloud_init    = false
  enable_qemu_agent = true
}

# ============================================================================
# Talos Sandbox VMs
# ============================================================================

module "talos_sandbox_vms" {
  source = "../../modules/proxmox-vm"

  count = var.talos_sandbox_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.talos_sandbox_vm_count
  vm_name      = var.talos_sandbox_vm_name
  vm_tags      = var.talos_sandbox_vm_tags

  template_id   = var.talos_template_id
  template_node = null # Template is on same node

  vm_cores     = var.talos_sandbox_vm_cores
  vm_memory    = var.talos_sandbox_vm_memory
  vm_disk_size = var.talos_sandbox_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  vm_mac_addresses  = var.talos_sandbox_vm_mac_addresses

  vm_user  = "talos"
  ssh_keys = var.ssh_keys

  use_cloud_init    = false
  enable_qemu_agent = true
}

# ============================================================================
# Talos Obs VMs
# ============================================================================

module "talos_obs_vms" {
  source = "../../modules/proxmox-vm"

  count = var.talos_obs_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.talos_obs_vm_count
  vm_name      = var.talos_obs_vm_name
  vm_tags      = var.talos_obs_vm_tags

  template_id   = var.talos_template_id
  template_node = null # Template is on same node

  vm_cores     = var.talos_obs_vm_cores
  vm_memory    = var.talos_obs_vm_memory
  vm_disk_size = var.talos_obs_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  vm_mac_addresses  = var.talos_obs_vm_mac_addresses

  vm_user  = "talos"
  ssh_keys = var.ssh_keys

  use_cloud_init    = false
  enable_qemu_agent = true
}
