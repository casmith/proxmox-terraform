variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "https://192.168.10.11:8006/api2/json"
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID (format: user@realm!tokenname)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "proxmox_user" {
  description = "Proxmox username (format: user@realm)"
  type        = string
  sensitive   = true
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS verification (set to true for self-signed certs)"
  type        = bool
  default     = true
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "ubuntu-vm-01"
}

variable "vm_description" {
  description = "VM description"
  type        = string
  default     = "Ubuntu 24.04 LTS VM managed by Terraform"
}

variable "vm_tags" {
  description = "Tags for the VM"
  type        = string
  default     = "terraform;ubuntu"
}

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Disk size (e.g., '20G')"
  type        = string
  default     = "20G"
}

variable "vm_storage" {
  description = "Storage location for VM disk"
  type        = string
  default     = "local-lvm"
}

variable "vm_network_bridge" {
  description = "Network bridge to use"
  type        = string
  default     = "vmbr0"
}

variable "template_name" {
  description = "Name of the cloud-init template to clone"
  type        = string
  default     = "ubuntu-2404-cloudinit-template"
}

variable "template_id" {
  description = "ID of the cloud-init template to clone"
  type        = number
  default     = 9000
}

variable "ssh_keys" {
  description = "SSH public keys to add to the VM"
  type        = string
  default     = ""
}

variable "vm_user" {
  description = "Default user for the VM"
  type        = string
  default     = "ubuntu"
}

variable "vm_ip_address" {
  description = "Static IP address for the VM (CIDR notation, e.g., '192.168.10.100/24')"
  type        = string
  default     = "dhcp"
}

variable "vm_gateway" {
  description = "Gateway IP address"
  type        = string
  default     = "192.168.10.1"
}
