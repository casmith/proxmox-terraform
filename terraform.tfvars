# VM Configuration
# This file can be safely committed to git
# Secrets are in secrets.tfvars (gitignored)

# Shared Configuration
vm_storage        = "local-lvm"
vm_network_bridge = "vmbr0"
vm_ip_address     = "dhcp"
vm_gateway        = "192.168.10.1"

# Ubuntu VMs
ubuntu_vm_count     = 2
ubuntu_vm_name      = "ubuntu-vm"
ubuntu_vm_cores     = 2
ubuntu_vm_memory    = 2048
ubuntu_vm_disk_size = 20

# Talos VMs
talos_vm_count = 2
talos_vm_memory	    = 4096
talos_vm_cores      = 4

# Talos Sandbox VMs (for experimentation)
talos_sandbox_vm_count  = 3
talos_sandbox_vm_name   = "talos-sandbox"
talos_sandbox_vm_cores  = 4
talos_sandbox_vm_memory = 4096

windows_vm_count = 0

freebsd_vm_count = 0
