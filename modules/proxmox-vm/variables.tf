variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}

variable "vm_name" {
  description = "Base name of the VM"
  type        = string
}

variable "vm_tags" {
  description = "Tags for the VM (semicolon separated)"
  type        = string
  default     = "terraform"
}

variable "template_id" {
  description = "ID of the cloud-init template to clone"
  type        = number
}

variable "template_node" {
  description = "Node where the template is located (for cross-node cloning)"
  type        = string
  default     = null
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
  description = "Disk size in GB"
  type        = number
  default     = 20
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

variable "vm_mac_addresses" {
  description = "List of MAC addresses for VMs (one per VM). If empty, Proxmox will auto-generate."
  type        = list(string)
  default     = []
}

variable "vm_ip_address" {
  description = "Static IP address for the VM (CIDR notation) or 'dhcp'"
  type        = string
  default     = "dhcp"
}

variable "vm_gateway" {
  description = "Gateway IP address (only used with static IP)"
  type        = string
  default     = null
}

variable "vm_user" {
  description = "Default user for the VM"
  type        = string
  default     = "ubuntu"
}

variable "ssh_keys" {
  description = "SSH public keys to add to the VM"
  type        = string
  default     = ""
}

variable "cloud_init_packages" {
  description = "List of packages to install via cloud-init"
  type        = list(string)
  default     = ["qemu-guest-agent"]
}

variable "cloud_init_runcmd" {
  description = "Additional commands to run via cloud-init"
  type        = list(string)
  default     = []
}

variable "enable_qemu_agent" {
  description = "Enable QEMU guest agent"
  type        = bool
  default     = true
}

variable "use_systemd_qemu_agent" {
  description = "Use systemd commands to start QEMU agent (set to false for FreeBSD/non-systemd OSes)"
  type        = bool
  default     = true
}

variable "custom_cloud_init" {
  description = "Custom cloud-init configuration (overrides default)"
  type        = string
  default     = ""
}

variable "use_cloud_init" {
  description = "Enable cloud-init configuration (disable for Talos and other systems that don't use cloud-init)"
  type        = bool
  default     = true
}

variable "disk_iothread" {
  description = "Enable dedicated I/O thread for disk operations (improves performance)"
  type        = bool
  default     = false
}

variable "disk_ssd" {
  description = "Enable SSD emulation (improves I/O scheduler decisions)"
  type        = bool
  default     = false
}

variable "disk_cache" {
  description = "Disk cache mode (none, directsync, writethrough, writeback, unsafe)"
  type        = string
  default     = "none"
}

variable "disk_discard" {
  description = "Enable discard/TRIM support (ignore or on)"
  type        = string
  default     = "ignore"
}
