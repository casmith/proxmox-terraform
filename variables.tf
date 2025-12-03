# Proxmox Provider Configuration
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

variable "proxmox_ssh_user" {
  description = "SSH username for Proxmox host (for uploading files)"
  type        = string
  default     = "root"
}

# Shared VM Configuration
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

variable "ssh_keys" {
  description = "SSH public keys to add to VMs"
  type        = string
  default     = ""
}

# Ubuntu VM Configuration
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

# Talos Linux VM Configuration
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
