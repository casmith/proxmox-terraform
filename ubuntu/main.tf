# Ubuntu VMs Configuration
module "ubuntu_vms" {
  source = "../modules/proxmox-vm"

  count = var.ubuntu_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.ubuntu_vm_count
  vm_name      = var.ubuntu_vm_name
  vm_tags      = var.ubuntu_vm_tags

  template_id = var.ubuntu_template_id

  vm_cores     = var.ubuntu_vm_cores
  vm_memory    = var.ubuntu_vm_memory
  vm_disk_size = var.ubuntu_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway

  vm_user  = var.ubuntu_vm_user
  ssh_keys = var.ssh_keys

  cloud_init_packages = ["qemu-guest-agent"]
  enable_qemu_agent   = true
}
