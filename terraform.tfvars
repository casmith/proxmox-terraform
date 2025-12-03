# VM Configuration
# This file can be safely committed to git
# Secrets are in secrets.tfvars (gitignored)

vm_count     = 2

vm_name      = "ubuntu-vm-01"
vm_cores     = 2
vm_memory    = 2048
vm_disk_size = "20G"

# Network Configuration
vm_ip_address      = "dhcp"
vm_gateway         = "192.168.10.1"
vm_network_bridge  = "vmbr0"

# Storage
vm_storage = "local-lvm"

# Template
template_name = "ubuntu-2404-cloudinit-template"
template_id   = 9000
