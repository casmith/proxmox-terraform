# pve1 Node Module
# All VMs deployed to pve1

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
  template_node = null  # Template is on same node

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
# Arch Linux VMs
# ============================================================================

module "archlinux_vms" {
  source = "../../modules/proxmox-vm"

  count = var.archlinux_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.archlinux_vm_count
  vm_name      = var.archlinux_vm_name
  vm_tags      = var.archlinux_vm_tags

  template_id   = var.archlinux_template_id
  template_node = null  # Template is on same node

  vm_cores     = var.archlinux_vm_cores
  vm_memory    = var.archlinux_vm_memory
  vm_disk_size = var.archlinux_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  vm_mac_addresses  = var.archlinux_vm_mac_addresses

  vm_user  = var.archlinux_vm_user
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
  template_node = null  # Template is on same node

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
  template_node = null  # Template is on same node

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
# Windows VMs
# ============================================================================

module "windows_vms" {
  source = "../../modules/proxmox-vm"

  count = var.windows_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.windows_vm_count
  vm_name      = var.windows_vm_name
  vm_tags      = var.windows_vm_tags

  template_id   = var.windows_template_id
  template_node = null  # Template is on same node

  vm_cores     = var.windows_vm_cores
  vm_memory    = var.windows_vm_memory
  vm_disk_size = var.windows_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway

  vm_user  = var.windows_vm_user
  ssh_keys = var.ssh_keys

  use_cloud_init    = false
  enable_qemu_agent = true
}

# ============================================================================
# FreeBSD VMs
# ============================================================================

module "freebsd_vms" {
  source = "../../modules/proxmox-vm"

  count = var.freebsd_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.freebsd_vm_count
  vm_name      = var.freebsd_vm_name
  vm_tags      = var.freebsd_vm_tags

  template_id   = var.freebsd_template_id
  template_node = null  # Template is on same node

  vm_cores     = var.freebsd_vm_cores
  vm_memory    = var.freebsd_vm_memory
  vm_disk_size = var.freebsd_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway

  vm_user  = var.freebsd_vm_user
  ssh_keys = var.ssh_keys

  cloud_init_packages       = ["qemu-guest-agent"]
  enable_qemu_agent         = true
  use_systemd_qemu_agent    = false  # FreeBSD uses rc.d, not systemd
}
