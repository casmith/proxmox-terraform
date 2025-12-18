# pve3 Node Module Variables
# These are pass-through variables from the root module

# ============================================================================
# Node Configuration
# ============================================================================

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
}

# ============================================================================
# Shared VM Configuration
# ============================================================================

variable "vm_storage" {
  description = "Storage location for VM disks"
  type        = string
}

variable "vm_network_bridge" {
  description = "Network bridge to use"
  type        = string
}

variable "vm_ip_address" {
  description = "Static IP address for VMs (CIDR notation) or 'dhcp'"
  type        = string
}

variable "vm_gateway" {
  description = "Gateway IP address"
  type        = string
}

variable "ssh_keys" {
  description = "SSH public keys for VM access"
  type        = string
}

# ============================================================================
# Template IDs (node-specific)
# ============================================================================

variable "ubuntu_template_id" {
  description = "ID of the Ubuntu template on this node"
  type        = number
}

variable "talos_template_id" {
  description = "ID of the Talos template on this node"
  type        = number
}



# ============================================================================
# Ubuntu VM Configuration
# ============================================================================

variable "ubuntu_vm_count" {
  description = "Number of Ubuntu VMs to create on this node"
  type        = number
}

variable "ubuntu_vm_name" {
  description = "Base name for Ubuntu VMs"
  type        = string
}

variable "ubuntu_vm_cores" {
  description = "Number of CPU cores for Ubuntu VMs"
  type        = number
}

variable "ubuntu_vm_memory" {
  description = "Memory in MB for Ubuntu VMs"
  type        = number
}

variable "ubuntu_vm_disk_size" {
  description = "Disk size in GB for Ubuntu VMs"
  type        = number
}

variable "ubuntu_vm_user" {
  description = "Default user for Ubuntu VMs"
  type        = string
  default     = "ubuntu"
}

variable "ubuntu_vm_tags" {
  description = "Tags for Ubuntu VMs (semicolon separated)"
  type        = string
  default     = "terraform;ubuntu"
}

variable "ubuntu_vm_mac_addresses" {
  description = "MAC addresses for Ubuntu VMs"
  type        = list(string)
  default     = []
}

# ============================================================================
# Ubuntu High-Memory VM Configuration
# ============================================================================

variable "ubuntu_highmem_vm_count" {
  description = "Number of high-memory Ubuntu VMs to create on this node"
  type        = number
  default     = 0
}

variable "ubuntu_highmem_vm_name" {
  description = "Base name for high-memory Ubuntu VMs"
  type        = string
  default     = "ubuntu-highmem-vm"
}

variable "ubuntu_highmem_vm_cores" {
  description = "Number of CPU cores for high-memory Ubuntu VMs"
  type        = number
  default     = 2
}

variable "ubuntu_highmem_vm_memory" {
  description = "Memory in MB for high-memory Ubuntu VMs"
  type        = number
  default     = 8192
}

variable "ubuntu_highmem_vm_disk_size" {
  description = "Disk size in GB for high-memory Ubuntu VMs"
  type        = number
  default     = 20
}

variable "ubuntu_highmem_vm_mac_addresses" {
  description = "MAC addresses for high-memory Ubuntu VMs"
  type        = list(string)
  default     = []
}

# ============================================================================
# Talos VM Configuration
# ============================================================================

variable "talos_vm_count" {
  description = "Number of Talos VMs to create on this node"
  type        = number
}

variable "talos_vm_name" {
  description = "Base name for Talos VMs"
  type        = string
}

variable "talos_vm_cores" {
  description = "Number of CPU cores for Talos VMs"
  type        = number
}

variable "talos_vm_memory" {
  description = "Memory in MB for Talos VMs"
  type        = number
}

variable "talos_vm_disk_size" {
  description = "Disk size in GB for Talos VMs"
  type        = number
}

variable "talos_vm_tags" {
  description = "Tags for Talos VMs (semicolon separated)"
  type        = string
  default     = "terraform;talos;kubernetes"
}

variable "talos_vm_mac_addresses" {
  description = "MAC addresses for Talos VMs"
  type        = list(string)
  default     = []
}

# ============================================================================
# Talos Sandbox VM Configuration
# ============================================================================

variable "talos_sandbox_vm_count" {
  description = "Number of Talos Sandbox VMs to create on this node"
  type        = number
}

variable "talos_sandbox_vm_name" {
  description = "Base name for Talos Sandbox VMs"
  type        = string
}

variable "talos_sandbox_vm_cores" {
  description = "Number of CPU cores for Talos Sandbox VMs"
  type        = number
}

variable "talos_sandbox_vm_memory" {
  description = "Memory in MB for Talos Sandbox VMs"
  type        = number
}

variable "talos_sandbox_vm_disk_size" {
  description = "Disk size in GB for Talos Sandbox VMs"
  type        = number
}

variable "talos_sandbox_vm_mac_addresses" {
  description = "MAC addresses for Talos Sandbox VMs"
  type        = list(string)
}

variable "talos_sandbox_vm_tags" {
  description = "Tags for Talos Sandbox VMs (semicolon separated)"
  type        = string
  default     = "terraform;talos;kubernetes;sandbox"
}
