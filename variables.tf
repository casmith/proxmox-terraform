# Root Variables File
# Node-based architecture - variables prefixed by node name (pve1_, pve2_)

# ============================================================================
# Proxmox Provider Configuration
# ============================================================================

variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "https://192.168.10.11:8006/api2/json"
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS verification (set to true for self-signed certs)"
  type        = bool
  default     = true
}

variable "proxmox_ssh_user" {
  description = "SSH username for Proxmox host (for uploading files)"
  type        = string
  default     = "root"
}

# ============================================================================
# Shared VM Configuration (used by all nodes)
# ============================================================================

variable "vm_storage" {
  description = "Storage location for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "vm_network_bridge" {
  description = "Network bridge to use"
  type        = string
  default     = "vmbr0"
}

variable "vm_ip_address" {
  description = "Static IP address for VMs (CIDR notation, e.g., '192.168.10.100/24') or 'dhcp'"
  type        = string
  default     = "dhcp"
}

variable "vm_gateway" {
  description = "Gateway IP address"
  type        = string
  default     = "192.168.10.1"
}

# ============================================================================
# pve1 Configuration
# ============================================================================

# Template IDs
variable "pve1_ubuntu_template_id" {
  description = "Ubuntu template ID on pve1"
  type        = number
  default     = 9000
}

variable "pve1_talos_template_id" {
  description = "Talos template ID on pve1"
  type        = number
  default     = 9001
}

variable "pve1_windows_template_id" {
  description = "Windows template ID on pve1"
  type        = number
  default     = 9002
}

variable "pve1_freebsd_template_id" {
  description = "FreeBSD template ID on pve1"
  type        = number
  default     = 9003
}

# Ubuntu VMs on pve1
variable "pve1_ubuntu_vm_count" {
  description = "Number of Ubuntu VMs on pve1"
  type        = number
  default     = 0
}

variable "pve1_ubuntu_vm_name" {
  description = "Base name for Ubuntu VMs on pve1"
  type        = string
  default     = "ubuntu-vm"
}

variable "pve1_ubuntu_vm_cores" {
  description = "CPU cores for Ubuntu VMs on pve1"
  type        = number
  default     = 2
}

variable "pve1_ubuntu_vm_memory" {
  description = "Memory in MB for Ubuntu VMs on pve1"
  type        = number
  default     = 2048
}

variable "pve1_ubuntu_vm_disk_size" {
  description = "Disk size in GB for Ubuntu VMs on pve1"
  type        = number
  default     = 20
}

variable "pve1_ubuntu_vm_user" {
  description = "Default user for Ubuntu VMs on pve1"
  type        = string
  default     = "ubuntu"
}

variable "pve1_ubuntu_vm_tags" {
  description = "Tags for Ubuntu VMs on pve1"
  type        = string
  default     = "terraform;ubuntu"
}

variable "pve1_ubuntu_vm_mac_addresses" {
  description = "MAC addresses for Ubuntu VMs on pve1"
  type        = list(string)
  default     = []
}

# Talos VMs on pve1
variable "pve1_talos_vm_count" {
  description = "Number of Talos VMs on pve1"
  type        = number
  default     = 0
}

variable "pve1_talos_vm_name" {
  description = "Base name for Talos VMs on pve1"
  type        = string
  default     = "talos-vm"
}

variable "pve1_talos_vm_cores" {
  description = "CPU cores for Talos VMs on pve1"
  type        = number
  default     = 4
}

variable "pve1_talos_vm_memory" {
  description = "Memory in MB for Talos VMs on pve1"
  type        = number
  default     = 4096
}

variable "pve1_talos_vm_disk_size" {
  description = "Disk size in GB for Talos VMs on pve1"
  type        = number
  default     = 30
}

variable "pve1_talos_vm_tags" {
  description = "Tags for Talos VMs on pve1"
  type        = string
  default     = "terraform;talos;kubernetes"
}

variable "pve1_talos_vm_mac_addresses" {
  description = "MAC addresses for Talos VMs on pve1"
  type        = list(string)
  default     = []
}

# Talos Sandbox VMs on pve1
variable "pve1_talos_sandbox_vm_count" {
  description = "Number of Talos Sandbox VMs on pve1"
  type        = number
  default     = 0
}

variable "pve1_talos_sandbox_vm_name" {
  description = "Base name for Talos Sandbox VMs on pve1"
  type        = string
  default     = "talos-sandbox-pve1"
}

variable "pve1_talos_sandbox_vm_cores" {
  description = "CPU cores for Talos Sandbox VMs on pve1"
  type        = number
  default     = 4
}

variable "pve1_talos_sandbox_vm_memory" {
  description = "Memory in MB for Talos Sandbox VMs on pve1"
  type        = number
  default     = 4096
}

variable "pve1_talos_sandbox_vm_disk_size" {
  description = "Disk size in GB for Talos Sandbox VMs on pve1"
  type        = number
  default     = 30
}

variable "pve1_talos_sandbox_vm_mac_addresses" {
  description = "MAC addresses for Talos Sandbox VMs on pve1"
  type        = list(string)
  default     = []
}

variable "pve1_talos_sandbox_vm_tags" {
  description = "Tags for Talos Sandbox VMs on pve1"
  type        = string
  default     = "terraform;talos;kubernetes;sandbox"
}

# Windows VMs on pve1
variable "pve1_windows_vm_count" {
  description = "Number of Windows VMs on pve1"
  type        = number
  default     = 0
}

variable "pve1_windows_vm_name" {
  description = "Base name for Windows VMs on pve1"
  type        = string
  default     = "windows-vm"
}

variable "pve1_windows_vm_cores" {
  description = "CPU cores for Windows VMs on pve1"
  type        = number
  default     = 4
}

variable "pve1_windows_vm_memory" {
  description = "Memory in MB for Windows VMs on pve1"
  type        = number
  default     = 8192
}

variable "pve1_windows_vm_disk_size" {
  description = "Disk size in GB for Windows VMs on pve1"
  type        = number
  default     = 60
}

variable "pve1_windows_vm_user" {
  description = "Default user for Windows VMs on pve1"
  type        = string
  default     = "Administrator"
}

variable "pve1_windows_vm_tags" {
  description = "Tags for Windows VMs on pve1"
  type        = string
  default     = "terraform;windows"
}

# FreeBSD VMs on pve1
variable "pve1_freebsd_vm_count" {
  description = "Number of FreeBSD VMs on pve1"
  type        = number
  default     = 0
}

variable "pve1_freebsd_vm_name" {
  description = "Base name for FreeBSD VMs on pve1"
  type        = string
  default     = "freebsd-vm"
}

variable "pve1_freebsd_vm_cores" {
  description = "CPU cores for FreeBSD VMs on pve1"
  type        = number
  default     = 2
}

variable "pve1_freebsd_vm_memory" {
  description = "Memory in MB for FreeBSD VMs on pve1"
  type        = number
  default     = 2048
}

variable "pve1_freebsd_vm_disk_size" {
  description = "Disk size in GB for FreeBSD VMs on pve1"
  type        = number
  default     = 20
}

variable "pve1_freebsd_vm_user" {
  description = "Default user for FreeBSD VMs on pve1"
  type        = string
  default     = "freebsd"
}

variable "pve1_freebsd_vm_tags" {
  description = "Tags for FreeBSD VMs on pve1"
  type        = string
  default     = "terraform;freebsd"
}

# ============================================================================
# pve2 Configuration
# ============================================================================

# Template IDs
variable "pve2_ubuntu_template_id" {
  description = "Ubuntu template ID on pve2"
  type        = number
  default     = 9100
}

variable "pve2_talos_template_id" {
  description = "Talos template ID on pve2"
  type        = number
  default     = 9101
}

variable "pve2_windows_template_id" {
  description = "Windows template ID on pve2"
  type        = number
  default     = 9102
}

variable "pve2_freebsd_template_id" {
  description = "FreeBSD template ID on pve2"
  type        = number
  default     = 9103
}

# Ubuntu VMs on pve2
variable "pve2_ubuntu_vm_count" {
  description = "Number of Ubuntu VMs on pve2"
  type        = number
  default     = 0
}

variable "pve2_ubuntu_vm_name" {
  description = "Base name for Ubuntu VMs on pve2"
  type        = string
  default     = "ubuntu-vm"
}

variable "pve2_ubuntu_vm_cores" {
  description = "CPU cores for Ubuntu VMs on pve2"
  type        = number
  default     = 2
}

variable "pve2_ubuntu_vm_memory" {
  description = "Memory in MB for Ubuntu VMs on pve2"
  type        = number
  default     = 2048
}

variable "pve2_ubuntu_vm_disk_size" {
  description = "Disk size in GB for Ubuntu VMs on pve2"
  type        = number
  default     = 20
}

variable "pve2_ubuntu_vm_user" {
  description = "Default user for Ubuntu VMs on pve2"
  type        = string
  default     = "ubuntu"
}

variable "pve2_ubuntu_vm_tags" {
  description = "Tags for Ubuntu VMs on pve2"
  type        = string
  default     = "terraform;ubuntu"
}

variable "pve2_ubuntu_vm_mac_addresses" {
  description = "MAC addresses for Ubuntu VMs on pve2"
  type        = list(string)
  default     = []
}

# Ubuntu High-Memory VMs on pve2
variable "pve2_ubuntu_highmem_vm_count" {
  description = "Number of high-memory Ubuntu VMs on pve2"
  type        = number
  default     = 0
}

variable "pve2_ubuntu_highmem_vm_name" {
  description = "Base name for high-memory Ubuntu VMs on pve2"
  type        = string
  default     = "ubuntu-highmem-vm"
}

variable "pve2_ubuntu_highmem_vm_cores" {
  description = "Number of CPU cores for high-memory Ubuntu VMs on pve2"
  type        = number
  default     = 2
}

variable "pve2_ubuntu_highmem_vm_memory" {
  description = "Memory in MB for high-memory Ubuntu VMs on pve2"
  type        = number
  default     = 8192
}

variable "pve2_ubuntu_highmem_vm_disk_size" {
  description = "Disk size in GB for high-memory Ubuntu VMs on pve2"
  type        = number
  default     = 20
}

variable "pve2_ubuntu_highmem_vm_mac_addresses" {
  description = "MAC addresses for high-memory Ubuntu VMs on pve2"
  type        = list(string)
  default     = []
}

# Talos VMs on pve2
variable "pve2_talos_vm_count" {
  description = "Number of Talos VMs on pve2"
  type        = number
  default     = 0
}

variable "pve2_talos_vm_name" {
  description = "Base name for Talos VMs on pve2"
  type        = string
  default     = "talos-vm"
}

variable "pve2_talos_vm_cores" {
  description = "CPU cores for Talos VMs on pve2"
  type        = number
  default     = 4
}

variable "pve2_talos_vm_memory" {
  description = "Memory in MB for Talos VMs on pve2"
  type        = number
  default     = 4096
}

variable "pve2_talos_vm_disk_size" {
  description = "Disk size in GB for Talos VMs on pve2"
  type        = number
  default     = 30
}

variable "pve2_talos_vm_tags" {
  description = "Tags for Talos VMs on pve2"
  type        = string
  default     = "terraform;talos;kubernetes"
}

variable "pve2_talos_vm_mac_addresses" {
  description = "MAC addresses for Talos VMs on pve2"
  type        = list(string)
  default     = []
}

# Talos Sandbox VMs on pve2
variable "pve2_talos_sandbox_vm_count" {
  description = "Number of Talos Sandbox VMs on pve2"
  type        = number
  default     = 0
}

variable "pve2_talos_sandbox_vm_name" {
  description = "Base name for Talos Sandbox VMs on pve2"
  type        = string
  default     = "talos-sandbox-pve2"
}

variable "pve2_talos_sandbox_vm_cores" {
  description = "CPU cores for Talos Sandbox VMs on pve2"
  type        = number
  default     = 4
}

variable "pve2_talos_sandbox_vm_memory" {
  description = "Memory in MB for Talos Sandbox VMs on pve2"
  type        = number
  default     = 4096
}

variable "pve2_talos_sandbox_vm_disk_size" {
  description = "Disk size in GB for Talos Sandbox VMs on pve2"
  type        = number
  default     = 30
}

variable "pve2_talos_sandbox_vm_mac_addresses" {
  description = "MAC addresses for Talos Sandbox VMs on pve2"
  type        = list(string)
  default     = []
}

variable "pve2_talos_sandbox_vm_tags" {
  description = "Tags for Talos Sandbox VMs on pve2"
  type        = string
  default     = "terraform;talos;kubernetes;sandbox"
}

# Windows VMs on pve2
variable "pve2_windows_vm_count" {
  description = "Number of Windows VMs on pve2"
  type        = number
  default     = 0
}

variable "pve2_windows_vm_name" {
  description = "Base name for Windows VMs on pve2"
  type        = string
  default     = "windows-vm"
}

variable "pve2_windows_vm_cores" {
  description = "CPU cores for Windows VMs on pve2"
  type        = number
  default     = 4
}

variable "pve2_windows_vm_memory" {
  description = "Memory in MB for Windows VMs on pve2"
  type        = number
  default     = 8192
}

variable "pve2_windows_vm_disk_size" {
  description = "Disk size in GB for Windows VMs on pve2"
  type        = number
  default     = 60
}

variable "pve2_windows_vm_user" {
  description = "Default user for Windows VMs on pve2"
  type        = string
  default     = "Administrator"
}

variable "pve2_windows_vm_tags" {
  description = "Tags for Windows VMs on pve2"
  type        = string
  default     = "terraform;windows"
}

# FreeBSD VMs on pve2
variable "pve2_freebsd_vm_count" {
  description = "Number of FreeBSD VMs on pve2"
  type        = number
  default     = 0
}

variable "pve2_freebsd_vm_name" {
  description = "Base name for FreeBSD VMs on pve2"
  type        = string
  default     = "freebsd-vm"
}

variable "pve2_freebsd_vm_cores" {
  description = "CPU cores for FreeBSD VMs on pve2"
  type        = number
  default     = 2
}

variable "pve2_freebsd_vm_memory" {
  description = "Memory in MB for FreeBSD VMs on pve2"
  type        = number
  default     = 2048
}

variable "pve2_freebsd_vm_disk_size" {
  description = "Disk size in GB for FreeBSD VMs on pve2"
  type        = number
  default     = 20
}

variable "pve2_freebsd_vm_user" {
  description = "Default user for FreeBSD VMs on pve2"
  type        = string
  default     = "freebsd"
}

variable "pve2_freebsd_vm_tags" {
  description = "Tags for FreeBSD VMs on pve2"
  type        = string
  default     = "terraform;freebsd"
}

# ============================================================================
# pve3 Configuration
# ============================================================================

# Template IDs
variable "pve3_ubuntu_template_id" {
  description = "Ubuntu template ID on pve3"
  type        = number
  default     = 9200
}

variable "pve3_talos_template_id" {
  description = "Talos template ID on pve3"
  type        = number
  default     = 9201
}

variable "pve3_windows_template_id" {
  description = "Windows template ID on pve3"
  type        = number
  default     = 9202
}

variable "pve3_freebsd_template_id" {
  description = "FreeBSD template ID on pve3"
  type        = number
  default     = 9203
}

# Ubuntu VMs on pve3
variable "pve3_ubuntu_vm_count" {
  description = "Number of Ubuntu VMs on pve3"
  type        = number
  default     = 0
}

variable "pve3_ubuntu_vm_name" {
  description = "Base name for Ubuntu VMs on pve3"
  type        = string
  default     = "ubuntu-vm"
}

variable "pve3_ubuntu_vm_cores" {
  description = "CPU cores for Ubuntu VMs on pve3"
  type        = number
  default     = 2
}

variable "pve3_ubuntu_vm_memory" {
  description = "Memory in MB for Ubuntu VMs on pve3"
  type        = number
  default     = 2048
}

variable "pve3_ubuntu_vm_disk_size" {
  description = "Disk size in GB for Ubuntu VMs on pve3"
  type        = number
  default     = 20
}

variable "pve3_ubuntu_vm_user" {
  description = "Default user for Ubuntu VMs on pve3"
  type        = string
  default     = "ubuntu"
}

variable "pve3_ubuntu_vm_tags" {
  description = "Tags for Ubuntu VMs on pve3"
  type        = string
  default     = "terraform;ubuntu"
}

variable "pve3_ubuntu_vm_mac_addresses" {
  description = "MAC addresses for Ubuntu VMs on pve3"
  type        = list(string)
  default     = []
}

# Ubuntu High-Memory VMs on pve3
variable "pve3_ubuntu_highmem_vm_count" {
  description = "Number of high-memory Ubuntu VMs on pve3"
  type        = number
  default     = 0
}

variable "pve3_ubuntu_highmem_vm_name" {
  description = "Base name for high-memory Ubuntu VMs on pve3"
  type        = string
  default     = "ubuntu-highmem-vm"
}

variable "pve3_ubuntu_highmem_vm_cores" {
  description = "Number of CPU cores for high-memory Ubuntu VMs on pve3"
  type        = number
  default     = 2
}

variable "pve3_ubuntu_highmem_vm_memory" {
  description = "Memory in MB for high-memory Ubuntu VMs on pve3"
  type        = number
  default     = 8192
}

variable "pve3_ubuntu_highmem_vm_disk_size" {
  description = "Disk size in GB for high-memory Ubuntu VMs on pve3"
  type        = number
  default     = 20
}

variable "pve3_ubuntu_highmem_vm_mac_addresses" {
  description = "MAC addresses for high-memory Ubuntu VMs on pve3"
  type        = list(string)
  default     = []
}

# Talos VMs on pve3
variable "pve3_talos_vm_count" {
  description = "Number of Talos VMs on pve3"
  type        = number
  default     = 0
}

variable "pve3_talos_vm_name" {
  description = "Base name for Talos VMs on pve3"
  type        = string
  default     = "talos-vm"
}

variable "pve3_talos_vm_cores" {
  description = "CPU cores for Talos VMs on pve3"
  type        = number
  default     = 4
}

variable "pve3_talos_vm_memory" {
  description = "Memory in MB for Talos VMs on pve3"
  type        = number
  default     = 4096
}

variable "pve3_talos_vm_disk_size" {
  description = "Disk size in GB for Talos VMs on pve3"
  type        = number
  default     = 30
}

variable "pve3_talos_vm_tags" {
  description = "Tags for Talos VMs on pve3"
  type        = string
  default     = "terraform;talos;kubernetes"
}

variable "pve3_talos_vm_mac_addresses" {
  description = "MAC addresses for Talos VMs on pve3"
  type        = list(string)
  default     = []
}

# Talos Sandbox VMs on pve3
variable "pve3_talos_sandbox_vm_count" {
  description = "Number of Talos Sandbox VMs on pve3"
  type        = number
  default     = 0
}

variable "pve3_talos_sandbox_vm_name" {
  description = "Base name for Talos Sandbox VMs on pve3"
  type        = string
  default     = "talos-sandbox-pve3"
}

variable "pve3_talos_sandbox_vm_cores" {
  description = "CPU cores for Talos Sandbox VMs on pve3"
  type        = number
  default     = 4
}

variable "pve3_talos_sandbox_vm_memory" {
  description = "Memory in MB for Talos Sandbox VMs on pve3"
  type        = number
  default     = 4096
}

variable "pve3_talos_sandbox_vm_disk_size" {
  description = "Disk size in GB for Talos Sandbox VMs on pve3"
  type        = number
  default     = 30
}

variable "pve3_talos_sandbox_vm_mac_addresses" {
  description = "MAC addresses for Talos Sandbox VMs on pve3"
  type        = list(string)
  default     = []
}

variable "pve3_talos_sandbox_vm_tags" {
  description = "Tags for Talos Sandbox VMs on pve3"
  type        = string
  default     = "terraform;talos;kubernetes;sandbox"
}

# Windows VMs on pve3
variable "pve3_windows_vm_count" {
  description = "Number of Windows VMs on pve3"
  type        = number
  default     = 0
}

variable "pve3_windows_vm_name" {
  description = "Base name for Windows VMs on pve3"
  type        = string
  default     = "windows-vm"
}

variable "pve3_windows_vm_cores" {
  description = "CPU cores for Windows VMs on pve3"
  type        = number
  default     = 4
}

variable "pve3_windows_vm_memory" {
  description = "Memory in MB for Windows VMs on pve3"
  type        = number
  default     = 8192
}

variable "pve3_windows_vm_disk_size" {
  description = "Disk size in GB for Windows VMs on pve3"
  type        = number
  default     = 60
}

variable "pve3_windows_vm_user" {
  description = "Default user for Windows VMs on pve3"
  type        = string
  default     = "Administrator"
}

variable "pve3_windows_vm_tags" {
  description = "Tags for Windows VMs on pve3"
  type        = string
  default     = "terraform;windows"
}

# FreeBSD VMs on pve3
variable "pve3_freebsd_vm_count" {
  description = "Number of FreeBSD VMs on pve3"
  type        = number
  default     = 0
}

variable "pve3_freebsd_vm_name" {
  description = "Base name for FreeBSD VMs on pve3"
  type        = string
  default     = "freebsd-vm"
}

variable "pve3_freebsd_vm_cores" {
  description = "CPU cores for FreeBSD VMs on pve3"
  type        = number
  default     = 2
}

variable "pve3_freebsd_vm_memory" {
  description = "Memory in MB for FreeBSD VMs on pve3"
  type        = number
  default     = 2048
}

variable "pve3_freebsd_vm_disk_size" {
  description = "Disk size in GB for FreeBSD VMs on pve3"
  type        = number
  default     = 20
}

variable "pve3_freebsd_vm_user" {
  description = "Default user for FreeBSD VMs on pve3"
  type        = string
  default     = "freebsd"
}

variable "pve3_freebsd_vm_tags" {
  description = "Tags for FreeBSD VMs on pve3"
  type        = string
  default     = "terraform;freebsd"
}
