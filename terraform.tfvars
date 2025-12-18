# Root Terraform Configuration
# Node-based architecture - configure VMs per node

# ============================================================================
# Shared Configuration (applies to all nodes)
# ============================================================================

vm_storage        = "local-lvm"
vm_network_bridge = "vmbr0"
vm_ip_address     = "dhcp"
vm_gateway        = "192.168.10.1"

# ============================================================================
# pve1 Node Configuration
# ============================================================================

# Template IDs on pve1 (local-lvm storage)
pve1_ubuntu_template_id    = 9000
pve1_talos_template_id     = 9001
pve1_archlinux_template_id = 9002
pve1_windows_template_id   = 9003
pve1_freebsd_template_id   = 9004

# Ubuntu VMs on pve1
pve1_ubuntu_vm_count         = 2
pve1_ubuntu_vm_name          = "ubuntu-vm"
pve1_ubuntu_vm_cores         = 2
pve1_ubuntu_vm_memory        = 2048
pve1_ubuntu_vm_disk_size     = 20
pve1_ubuntu_vm_mac_addresses = ["52:54:00:06:d2:7f", "52:54:00:33:3f:a8"]

# Arch Linux VMs on pve1
pve1_archlinux_vm_count     = 1
pve1_archlinux_vm_name      = "arch-vm"
pve1_archlinux_vm_cores     = 2
pve1_archlinux_vm_memory    = 2048
pve1_archlinux_vm_disk_size = 20

# Talos VMs on pve1
pve1_talos_vm_count         = 2
pve1_talos_vm_name          = "talos-vm"
pve1_talos_vm_cores         = 4
pve1_talos_vm_memory        = 4096
pve1_talos_vm_disk_size     = 30
pve1_talos_vm_mac_addresses = ["52:54:00:c4:9c:d7", "52:54:00:4d:e5:5d"]

# Talos Sandbox VMs on pve1
pve1_talos_sandbox_vm_count         = 1
pve1_talos_sandbox_vm_name          = "talos-sandbox-pve1"
pve1_talos_sandbox_vm_cores         = 4
pve1_talos_sandbox_vm_memory        = 4096
pve1_talos_sandbox_vm_disk_size     = 30
pve1_talos_sandbox_vm_mac_addresses = ["52:54:00:5a:52:e9"]

# Windows VMs on pve1 (disabled)
pve1_windows_vm_count = 0

# FreeBSD VMs on pve1 (disabled)
pve1_freebsd_vm_count = 0

# ============================================================================
# pve2 Node Configuration
# ============================================================================

# Template IDs on pve2 (local-lvm storage)
pve2_ubuntu_template_id  = 9100
pve2_talos_template_id   = 9101
pve2_windows_template_id = 9102
pve2_freebsd_template_id = 9103

# Ubuntu VMs on pve2
pve2_ubuntu_vm_count         = 1
pve2_ubuntu_vm_name          = "ubuntu-vm"
pve2_ubuntu_vm_cores         = 2
pve2_ubuntu_vm_memory        = 2048
pve2_ubuntu_vm_disk_size     = 20
pve2_ubuntu_vm_mac_addresses = ["52:54:00:36:34:cb"]

# Ubuntu High-Memory VMs on pve2
pve2_ubuntu_highmem_vm_count         = 1
pve2_ubuntu_highmem_vm_name          = "ubuntu-highmem-vm"
pve2_ubuntu_highmem_vm_cores         = 2
pve2_ubuntu_highmem_vm_memory        = 8192
pve2_ubuntu_highmem_vm_disk_size     = 20
pve2_ubuntu_highmem_vm_mac_addresses = ["52:54:00:0d:69:41"]

# Talos VMs on pve2
pve2_talos_vm_count         = 1
pve2_talos_vm_name          = "talos-vm"
pve2_talos_vm_cores         = 4
pve2_talos_vm_memory        = 4096
pve2_talos_vm_disk_size     = 30
pve2_talos_vm_mac_addresses = ["52:54:00:cd:0f:61"]


# Talos Sandbox VMs on pve2
pve2_talos_sandbox_vm_count         = 2
pve2_talos_sandbox_vm_name          = "talos-sandbox-pve2"
pve2_talos_sandbox_vm_cores         = 4
pve2_talos_sandbox_vm_memory        = 4096
pve2_talos_sandbox_vm_disk_size     = 30
pve2_talos_sandbox_vm_mac_addresses = ["52:54:00:0c:08:a7", "52:54:00:9c:30:b8"]

# Windows VMs on pve2 (disabled)
pve2_windows_vm_count = 0

# FreeBSD VMs on pve2 (disabled)
pve2_freebsd_vm_count = 0

# ============================================================================
# pve3 Node Configuration
# ============================================================================

# Template IDs on pve3 (local-lvm storage)
pve3_ubuntu_template_id  = 9200
pve3_talos_template_id   = 9201
pve3_windows_template_id = 9202
pve3_freebsd_template_id = 9203

# Ubuntu VMs on pve3
pve3_ubuntu_vm_count         = 1
pve3_ubuntu_vm_name          = "ubuntu-vm"
pve3_ubuntu_vm_cores         = 2
pve3_ubuntu_vm_memory        = 2048
pve3_ubuntu_vm_disk_size     = 20
pve3_ubuntu_vm_mac_addresses = ["52:54:00:e9:c8:5a"]

# Ubuntu High-Memory VMs on pve3
pve3_ubuntu_highmem_vm_count         = 1
pve3_ubuntu_highmem_vm_name          = "ubuntu-highmem-vm"
pve3_ubuntu_highmem_vm_cores         = 2
pve3_ubuntu_highmem_vm_memory        = 8192
pve3_ubuntu_highmem_vm_disk_size     = 20
pve3_ubuntu_highmem_vm_mac_addresses = ["52:54:00:e5:d5:f4"]

# Talos VMs on pve3 (disabled)
pve3_talos_vm_count = 0

# Talos Sandbox VMs on pve3 (disabled)
pve3_talos_sandbox_vm_count = 0

# Windows VMs on pve3 (disabled)
pve3_windows_vm_count = 0

# FreeBSD VMs on pve3 (disabled)
pve3_freebsd_vm_count = 0
