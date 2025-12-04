# FreeBSD-specific variables

variable "freebsd_vm_count" {
  description = "Number of FreeBSD VMs to create"
  type        = number
  default     = 0
}

variable "freebsd_vm_name" {
  description = "Base name for FreeBSD VMs"
  type        = string
  default     = "freebsd-vm"
}

variable "freebsd_vm_tags" {
  description = "Tags for FreeBSD VMs (semicolon separated)"
  type        = string
  default     = "terraform;freebsd"
}

variable "freebsd_template_id" {
  description = "ID of the FreeBSD cloud-init template to clone"
  type        = number
  default     = 9003
}

variable "freebsd_vm_cores" {
  description = "Number of CPU cores for FreeBSD VMs"
  type        = number
  default     = 2
}

variable "freebsd_vm_memory" {
  description = "Memory in MB for FreeBSD VMs"
  type        = number
  default     = 2048
}

variable "freebsd_vm_disk_size" {
  description = "Disk size in GB for FreeBSD VMs"
  type        = number
  default     = 20
}

variable "freebsd_vm_user" {
  description = "Default user for FreeBSD VMs"
  type        = string
  default     = "freebsd"
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
