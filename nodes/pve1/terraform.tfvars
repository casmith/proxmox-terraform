# pve1 Node Configuration
# Template IDs and VM counts specific to pve1

# Node identification
proxmox_node = "pve1"

# Template IDs for pve1 (local-lvm storage)
ubuntu_template_id    = 9000
talos_template_id     = 9001
archlinux_template_id = 9002

# Ubuntu VMs on pve1
ubuntu_vm_count     = 2
ubuntu_vm_name      = "ubuntu-vm"
ubuntu_vm_cores     = 2
ubuntu_vm_memory    = 2048
ubuntu_vm_disk_size = 20

# Arch Linux VMs on pve1
archlinux_vm_count     = 1
archlinux_vm_name      = "arch-vm"
archlinux_vm_cores     = 2
archlinux_vm_memory    = 2048
archlinux_vm_disk_size = 20

# Talos VMs on pve1
talos_vm_count     = 2
talos_vm_name      = "talos-vm"
talos_vm_cores     = 4
talos_vm_memory    = 4096
talos_vm_disk_size = 30

# Talos Sandbox VMs on pve1
talos_sandbox_vm_count         = 1
talos_sandbox_vm_name          = "talos-sandbox-pve1"
talos_sandbox_vm_cores         = 4
talos_sandbox_vm_memory        = 4096
talos_sandbox_vm_disk_size     = 30
talos_sandbox_vm_mac_addresses = ["BC:24:11:51:59:8B"]
