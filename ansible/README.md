# Ansible Configuration for Proxmox VMs

This directory contains Ansible playbooks for configuring VMs created with Terraform.

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
