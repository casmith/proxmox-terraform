# Talos Linux Sandbox VMs Configuration
module "talos_vms" {
  source = "../modules/proxmox-vm"

  count = var.talos_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.talos_vm_count
  vm_name      = var.talos_vm_name
  vm_tags      = var.talos_vm_tags

  template_id   = var.talos_template_id
  template_node = var.talos_template_node

  vm_cores     = var.talos_vm_cores
  vm_memory    = var.talos_vm_memory
  vm_disk_size = var.talos_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway
  vm_mac_addresses  = var.talos_vm_mac_addresses

  # Talos doesn't use cloud-init - disable it to prevent interference
  use_cloud_init    = false
  vm_user           = "talos"
  ssh_keys          = ""
  enable_qemu_agent = true

  # Talos ignores cloud-init packages/commands - agent must be in image
  cloud_init_packages = []
  cloud_init_runcmd   = []
}
