# Ubuntu-specific variables

variable "ubuntu_vm_count" {
  description = "Number of Ubuntu VMs to create"
  type        = number
  default     = 0
}

variable "ubuntu_vm_name" {
  description = "Base name for Ubuntu VMs"
  type        = string
  default     = "ubuntu-vm"
}

variable "ubuntu_vm_tags" {
  description = "Tags for Ubuntu VMs (semicolon separated)"
  type        = string
  default     = "terraform;ubuntu"
}

variable "ubuntu_template_id" {
  description = "ID of the Ubuntu cloud-init template to clone"
  type        = number
  default     = 9000
}

variable "ubuntu_vm_cores" {
  description = "Number of CPU cores for Ubuntu VMs"
  type        = number
  default     = 2
}

variable "ubuntu_vm_memory" {
  description = "Memory in MB for Ubuntu VMs"
  type        = number
  default     = 2048
}

variable "ubuntu_vm_disk_size" {
  description = "Disk size in GB for Ubuntu VMs"
  type        = number
  default     = 20
}

variable "ubuntu_vm_user" {
  description = "Default user for Ubuntu VMs"
  type        = string
  default     = "ubuntu"
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
  description = "SSH public keys to add to VMs"
  type        = string
}
