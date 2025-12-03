# Talos Linux-specific variables

variable "talos_vm_count" {
  description = "Number of Talos Linux VMs to create"
  type        = number
  default     = 0
}

variable "talos_vm_name" {
  description = "Base name for Talos VMs"
  type        = string
  default     = "talos-vm"
}

variable "talos_vm_tags" {
  description = "Tags for Talos VMs (semicolon separated)"
  type        = string
  default     = "terraform;talos;kubernetes"
}

variable "talos_template_id" {
  description = "ID of the Talos Linux template to clone"
  type        = number
  default     = 9001
}

variable "talos_vm_cores" {
  description = "Number of CPU cores for Talos VMs"
  type        = number
  default     = 2
}

variable "talos_vm_memory" {
  description = "Memory in MB for Talos VMs"
  type        = number
  default     = 4096
}

variable "talos_vm_disk_size" {
  description = "Disk size in GB for Talos VMs"
  type        = number
  default     = 30
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
  description = "SSH public keys (not used by Talos but required for module compatibility)"
  type        = string
  default     = ""
}
