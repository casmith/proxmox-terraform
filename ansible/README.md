# Ansible Configuration for Proxmox VMs

This directory contains Ansible playbooks for creating Proxmox templates and configuring VMs created with Terraform.

## Template Creation Playbooks

### Ubuntu 24.04 Template
```bash
ansible-playbook setup-ubuntu2404-template.yml
```
Creates template ID 9000 with cloud-init and QEMU agent support.

### Talos Linux Template
```bash
ansible-playbook setup-talos-template.yml
```
Creates template ID 9001 with Kubernetes-optimized Talos Linux.

### Windows 11 Template
```bash
ansible-playbook setup-windows-template.yml
```
Creates template ID 9002. **Note:** Requires manual steps for Windows installation.

- **Quick Start:** See `WINDOWS_QUICK_START.md` for 5-step setup (~30 min)
- **Detailed Guide:** See `WINDOWS_SETUP_GUIDE.md` for comprehensive instructions

### FreeBSD 15.0 Template
```bash
ansible-playbook setup-freebsd-template.yml
```
Creates template ID 9003 with cloud-init and QEMU agent support.

## VM Configuration Playbooks

## Setup

1. **Install Ansible** (if not already installed):
   ```bash
   # On Arch Linux
   sudo pacman -S ansible

   # Or use mise
   mise use ansible@latest
   ```

2. **Update the inventory** with your VM's IP address:
   Edit `inventory.ini` and replace `<VM_IP_HERE>` with the actual IP address from Proxmox.

3. **Test connectivity**:
   ```bash
   ansible proxmox_vms -m ping
   ```

## Install QEMU Guest Agent

Run the playbook to install the QEMU guest agent:

```bash
ansible-playbook install-qemu-agent.yml
```

## Other Useful Playbooks

### Run ad-hoc commands

```bash
# Check uptime
ansible proxmox_vms -a "uptime"

# Update all packages
ansible proxmox_vms -m apt -a "upgrade=dist update_cache=yes" -b

# Reboot VMs
ansible proxmox_vms -m reboot -b
```

## Creating New Playbooks

See `install-qemu-agent.yml` as a template for creating new playbooks to:
- Install Docker
- Configure web servers
- Deploy applications
- Set up monitoring
