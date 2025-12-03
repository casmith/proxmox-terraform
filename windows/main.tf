# Windows VMs Configuration
# NOTE: This is a template. You'll need to:
# 1. Create Windows template in Proxmox (use ansible/setup-windows-template.yml when created)
# 2. Configure Windows-specific settings (RDP, firewall, etc.)
# 3. Adjust cloud-init settings or use alternative provisioning

module "windows_vms" {
  source = "../modules/proxmox-vm"

  count = var.windows_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.windows_vm_count
  vm_name      = var.windows_vm_name
  vm_tags      = var.windows_vm_tags

  template_id = var.windows_template_id

  vm_cores     = var.windows_vm_cores
  vm_memory    = var.windows_vm_memory
  vm_disk_size = var.windows_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway

  # Windows configuration
  # Note: Windows may require different cloud-init approach or cloudbase-init
  vm_user           = var.windows_vm_user
  ssh_keys          = var.ssh_keys
  enable_qemu_agent = true

  # Windows-specific packages/commands will need adjustment
  cloud_init_packages = []
  cloud_init_runcmd   = []
}
