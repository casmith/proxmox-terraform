# FreeBSD VMs Configuration
module "freebsd_vms" {
  source = "../modules/proxmox-vm"

  count = var.freebsd_vm_count > 0 ? 1 : 0

  proxmox_node = var.proxmox_node
  vm_count     = var.freebsd_vm_count
  vm_name      = var.freebsd_vm_name
  vm_tags      = var.freebsd_vm_tags

  template_id = var.freebsd_template_id

  vm_cores     = var.freebsd_vm_cores
  vm_memory    = var.freebsd_vm_memory
  vm_disk_size = var.freebsd_vm_disk_size
  vm_storage   = var.vm_storage

  vm_network_bridge = var.vm_network_bridge
  vm_ip_address     = var.vm_ip_address
  vm_gateway        = var.vm_gateway

  vm_user  = var.freebsd_vm_user
  ssh_keys = var.ssh_keys

  # QEMU agent is pre-installed in the template
  # Ensure virtio_console is loaded and agent is enabled
  enable_qemu_agent = true

  # No additional packages needed (already in template)
  cloud_init_packages = []

  # Ensure virtio_console kernel module and QEMU agent service are configured
  cloud_init_runcmd = [
    "echo 'virtio_console_load=\"YES\"' >> /boot/loader.conf",
    "kldload virtio_console || true",
    "sysrc qemu_guest_agent_enable=\"YES\"",
    "sysrc qemu_guest_agent_flags=\"-d -v -l /var/log/qemu-ga.log\"",
    "service qemu-guest-agent restart || service qemu-guest-agent start"
  ]
}
