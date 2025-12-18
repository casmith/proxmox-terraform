# Arch Linux Template Setup Guide

This guide explains how to create and use Arch Linux VM templates in your Proxmox environment.

## Overview

The Arch Linux template uses the official Arch Linux cloud image, which comes pre-configured with:
- **cloud-init** for automatic user/SSH key provisioning
- **qemu-guest-agent** for IP address detection and VM management
- **openssh** for remote access
- **systemd-networkd** for network configuration

## Template IDs

Following the per-node template ID schema:
- **pve1**: 9002
- **pve2**: 9102
- **pve3**: 9202

## Creating the Template

### Option 1: Create on All Nodes (Recommended)

Create Arch Linux templates on all nodes at once:

```bash
ansible-playbook ansible/setup-all-templates.yml -i ansible/proxmox-inventory.ini
```

This will create Ubuntu, Talos, and Arch Linux templates on all nodes.

### Option 2: Create on Specific Node

Create Arch Linux template on a specific node:

```bash
# On pve1 (template ID 9002)
ansible-playbook ansible/setup-archlinux-template.yml -e target_hosts=proxmox-01

# On pve2 (template ID 9102)
ansible-playbook ansible/setup-archlinux-template.yml -e target_hosts=proxmox-02 -e archlinux_template_id=9102

# On pve3 (template ID 9202)
ansible-playbook ansible/setup-archlinux-template.yml -e target_hosts=proxmox-03 -e archlinux_template_id=9202
```

## Using with Terraform

### Example 1: Single Arch Linux VM on pve1

Add to your `nodes/pve1/main.tf`:

```hcl
module "archlinux_vms" {
  source = "../../modules/proxmox-vm"
  count  = var.archlinux_vm_count > 0 ? 1 : 0

  proxmox_node    = var.proxmox_node
  vm_count        = var.archlinux_vm_count
  vm_name         = var.archlinux_vm_name
  template_id     = var.archlinux_template_id
  vm_cores        = var.archlinux_vm_cores
  vm_memory       = var.archlinux_vm_memory
  vm_disk_size    = var.archlinux_vm_disk_size
  mac_addresses   = var.archlinux_vm_mac_addresses

  # User configuration
  vm_user         = var.vm_user
  vm_password     = var.vm_password
  ssh_keys        = var.ssh_keys

  # Arch Linux specific: Install additional packages via cloud-init
  packages = [
    "qemu-guest-agent",  # Already in cloud image, but ensure it's latest
    "vim",
    "git",
    "htop",
  ]

  # Enable QEMU agent (required for IP detection)
  qemu_agent_enabled = true
}
```

Add to `nodes/pve1/variables.tf`:

```hcl
# Arch Linux VMs
variable "archlinux_vm_count" {
  description = "Number of Arch Linux VMs to create on pve1"
  type        = number
}

variable "archlinux_vm_name" {
  description = "Base name for Arch Linux VMs on pve1"
  type        = string
}

variable "archlinux_template_id" {
  description = "Template ID for Arch Linux on pve1"
  type        = number
}

variable "archlinux_vm_cores" {
  description = "CPU cores for Arch Linux VMs on pve1"
  type        = number
}

variable "archlinux_vm_memory" {
  description = "Memory (MB) for Arch Linux VMs on pve1"
  type        = number
}

variable "archlinux_vm_disk_size" {
  description = "Disk size for Arch Linux VMs on pve1"
  type        = string
}

variable "archlinux_vm_mac_addresses" {
  description = "MAC addresses for Arch Linux VMs on pve1"
  type        = list(string)
  default     = []
}
```

Add to `nodes/pve1/terraform.tfvars`:

```hcl
# Arch Linux template configuration
archlinux_template_id = 9002

# Arch Linux VMs
archlinux_vm_count     = 2
archlinux_vm_name      = "arch-vm"
archlinux_vm_cores     = 2
archlinux_vm_memory    = 2048
archlinux_vm_disk_size = "20G"
```

Add to root `main.tf` to pass variables to the pve1 module:

```hcl
module "pve1" {
  source = "./nodes/pve1"

  # ... existing variables ...

  # Arch Linux
  archlinux_vm_count         = var.pve1_archlinux_vm_count
  archlinux_vm_name          = var.pve1_archlinux_vm_name
  archlinux_template_id      = var.pve1_archlinux_template_id
  archlinux_vm_cores         = var.pve1_archlinux_vm_cores
  archlinux_vm_memory        = var.pve1_archlinux_vm_memory
  archlinux_vm_disk_size     = var.pve1_archlinux_vm_disk_size
  archlinux_vm_mac_addresses = var.pve1_archlinux_vm_mac_addresses
}
```

Add to root `variables.tf`:

```hcl
# pve1 Arch Linux VMs
variable "pve1_archlinux_vm_count" {
  description = "Number of Arch Linux VMs on pve1"
  type        = number
}

variable "pve1_archlinux_vm_name" {
  description = "Base name for Arch Linux VMs on pve1"
  type        = string
}

variable "pve1_archlinux_template_id" {
  description = "Template ID for Arch Linux on pve1"
  type        = number
}

variable "pve1_archlinux_vm_cores" {
  description = "CPU cores for Arch Linux VMs on pve1"
  type        = number
}

variable "pve1_archlinux_vm_memory" {
  description = "Memory for Arch Linux VMs on pve1"
  type        = number
}

variable "pve1_archlinux_vm_disk_size" {
  description = "Disk size for Arch Linux VMs on pve1"
  type        = string
}

variable "pve1_archlinux_vm_mac_addresses" {
  description = "MAC addresses for Arch Linux VMs on pve1"
  type        = list(string)
  default     = []
}
```

Add to root `terraform.tfvars`:

```hcl
# pve1 Arch Linux VMs
pve1_archlinux_vm_count     = 2
pve1_archlinux_vm_name      = "arch-vm"
pve1_archlinux_template_id  = 9002
pve1_archlinux_vm_cores     = 2
pve1_archlinux_vm_memory    = 2048
pve1_archlinux_vm_disk_size = "20G"
```

### Example 2: Arch Linux with Custom Cloud-Init

For more advanced configuration:

```hcl
module "archlinux_dev" {
  source = "../../modules/proxmox-vm"
  count  = var.archlinux_dev_vm_count > 0 ? 1 : 0

  proxmox_node    = var.proxmox_node
  vm_count        = var.archlinux_dev_vm_count
  vm_name         = "arch-dev"
  template_id     = var.archlinux_template_id
  vm_cores        = 4
  vm_memory       = 8192
  vm_disk_size    = "50G"

  vm_user         = var.vm_user
  vm_password     = var.vm_password
  ssh_keys        = var.ssh_keys

  # Install development tools
  packages = [
    "base-devel",
    "git",
    "docker",
    "kubectl",
    "helm",
    "python",
    "python-pip",
    "nodejs",
    "npm",
  ]

  # Run custom commands after package installation
  run_cmds = [
    "systemctl enable --now docker",
    "usermod -aG docker ${var.vm_user}",
    "pacman -Syu --noconfirm",  # Update system packages
  ]

  qemu_agent_enabled = true
}
```

## Important Notes

### Rolling Release Model

Arch Linux is a rolling release distribution:
- The cloud image is updated monthly with the latest packages
- New VMs will always use the latest template version
- Consider running `pacman -Syu` regularly to keep VMs updated

### Package Management

Update packages on running VMs:

```bash
# SSH into the VM
ssh user@vm-ip

# Update package database and upgrade all packages
sudo pacman -Syu

# Install new packages
sudo pacman -S package-name
```

### Cloud-Init Support

The Arch Linux cloud image includes:
- **cloud-init** service enabled by default
- Supports all standard cloud-init features:
  - User creation
  - SSH key injection
  - Package installation
  - Custom commands
  - Network configuration

### QEMU Guest Agent

The template includes `qemu-guest-agent` which:
- Allows Terraform to detect VM IP addresses automatically
- Enables graceful VM shutdown from Proxmox
- Provides better VM integration with Proxmox

The agent is automatically started by systemd and doesn't require manual configuration.

### First Boot

On first boot, cloud-init will:
1. Create the specified user
2. Install SSH keys
3. Install additional packages (if specified)
4. Run custom commands (if specified)
5. Start the QEMU guest agent

This process typically takes 30-90 seconds. The VM IP will appear in Terraform outputs once the QEMU guest agent reports it.

## Troubleshooting

### IP Address Not Appearing

If Terraform shows "Waiting for IP..." for more than 2 minutes:

1. Check cloud-init status:
   ```bash
   ssh user@vm-ip  # Use Proxmox console if SSH not working
   cloud-init status
   ```

2. Check QEMU guest agent:
   ```bash
   systemctl status qemu-guest-agent
   ```

3. View cloud-init logs:
   ```bash
   sudo journalctl -u cloud-init-local
   sudo journalctl -u cloud-init
   ```

### Template Not Found

If Terraform reports template not found:
- Verify template exists: `qm list` on the Proxmox node
- Check template ID matches in terraform.tfvars
- Ensure template was created on the correct node (per-node templates)

### Package Installation Failures

If packages fail to install via cloud-init:
- Check cloud-init logs: `sudo cat /var/log/cloud-init-output.log`
- Verify package names are correct for Arch Linux
- Check network connectivity during first boot

## Additional Resources

- [Arch Linux Cloud Images](https://geo.mirror.pkgbuild.com/images/)
- [Arch Linux Documentation](https://wiki.archlinux.org/)
- [Cloud-Init Documentation](https://cloudinit.readthedocs.io/)
- [QEMU Guest Agent](https://wiki.qemu.org/Features/GuestAgent)
