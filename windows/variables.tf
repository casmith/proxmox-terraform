# Windows-specific variables

variable "windows_vm_count" {
  description = "Number of Windows VMs to create"
  type        = number
  default     = 0
}

variable "windows_vm_name" {
  description = "Base name for Windows VMs"
  type        = string
  default     = "windows-vm"
}

variable "windows_vm_tags" {
  description = "Tags for Windows VMs (semicolon separated)"
  type        = string
  default     = "terraform;windows"
}

variable "windows_template_id" {
  description = "ID of the Windows template to clone"
  type        = number
  default     = 9002 # Suggested ID - adjust as needed
}

variable "windows_vm_cores" {
  description = "Number of CPU cores for Windows VMs"
  type        = number
  default     = 4 # Windows typically needs more resources
}

variable "windows_vm_memory" {
  description = "Memory in MB for Windows VMs"
  type        = number
  default     = 8192 # Windows typically needs more RAM
}

variable "windows_vm_disk_size" {
  description = "Disk size in GB for Windows VMs"
  type        = number
  default     = 60 # Windows needs more disk space
}

variable "windows_vm_user" {
  description = "Default user for Windows VMs"
  type        = string
  default     = "Administrator"
}

# Shared variables that must be passed from root
variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
}

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
  description = "SSH public keys (may not apply to Windows)"
  type        = string
  default     = ""
}
