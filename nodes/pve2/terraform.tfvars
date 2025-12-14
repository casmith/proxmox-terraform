# pve2 Node Configuration
# Template IDs and VM counts specific to pve2

# Node identification
proxmox_node = "pve2"

# Template IDs for pve2 (local-lvm storage)
ubuntu_template_id = 9100
talos_template_id  = 9101
windows_template_id = 9102
freebsd_template_id = 9103

# Ubuntu VMs on pve2 (disabled by default)
ubuntu_vm_count     = 0
ubuntu_vm_name      = "ubuntu-vm"
ubuntu_vm_cores     = 2
ubuntu_vm_memory    = 2048
ubuntu_vm_disk_size = 20

# Talos VMs on pve2 (disabled by default)
talos_vm_count     = 0
talos_vm_name      = "talos-vm"
talos_vm_cores     = 4
talos_vm_memory    = 4096
talos_vm_disk_size = 30

# Talos Sandbox VMs on pve2
talos_sandbox_vm_count         = 2
talos_sandbox_vm_name          = "talos-sandbox-pve2"
talos_sandbox_vm_cores         = 4
talos_sandbox_vm_memory        = 4096
talos_sandbox_vm_disk_size     = 30
talos_sandbox_vm_mac_addresses = ["BC:24:11:42:4E:F3", "BC:24:11:B2:0B:F7"]

# Windows VMs on pve2 (disabled by default)
windows_vm_count     = 0
windows_vm_name      = "windows-vm"
windows_vm_cores     = 4
windows_vm_memory    = 8192
windows_vm_disk_size = 60

# FreeBSD VMs on pve2 (disabled by default)
freebsd_vm_count     = 0
freebsd_vm_name      = "freebsd-vm"
freebsd_vm_cores     = 2
freebsd_vm_memory    = 2048
freebsd_vm_disk_size = 20
