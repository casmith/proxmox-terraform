# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository manages Ubuntu 24.04 VMs on Proxmox using Terraform for infrastructure provisioning and Ansible for configuration management. The workflow follows a two-phase approach: Terraform creates VMs from cloud-init templates, then Ansible configures them.

## Tool Management

All development tools (Terraform, Ansible, Python) are managed via `mise`. Always prefix commands with `mise exec --` or activate mise in your shell.

## Common Commands

### Terraform Operations

```bash
# Initialize Terraform
mise exec -- terraform init

# Validate configuration
mise exec -- terraform validate

# Plan changes (preview)
mise exec -- terraform plan -var-file="secrets.tfvars"

# Apply changes (create/update VMs)
mise exec -- terraform apply -var-file="secrets.tfvars"

# Destroy infrastructure
mise exec -- terraform destroy -var-file="secrets.tfvars"

# Format Terraform files
mise exec -- terraform fmt
```

**Critical**: Always include `-var-file="secrets.tfvars"` when running plan/apply/destroy commands. The project separates secrets from configuration.

### Ansible Operations

```bash
# Test connectivity to VMs
ansible proxmox_vms -m ping

# Install QEMU guest agent on VMs
ansible-playbook ansible/install-qemu-agent.yml

# Create Proxmox template (runs on Proxmox host)
ansible-playbook ansible/setup-proxmox-template.yml

# Run ad-hoc commands
ansible proxmox_vms -a "uptime"
ansible proxmox_vms -m apt -a "upgrade=dist update_cache=yes" -b
```

## Architecture

### Two-File Variable System

The project uses a security-conscious variable configuration:

1. **secrets.tfvars** (gitignored): Contains sensitive data
   - Proxmox API token ID and secret
   - SSH public keys
   - Never committed to version control

2. **terraform.tfvars** (safe to commit): Contains non-sensitive VM configuration
   - VM name, CPU, memory, disk size
   - Network settings
   - Storage and template references

### Terraform Structure

- **versions.tf**: Provider configuration (bpg/proxmox ~> 0.70)
- **variables.tf**: All variable definitions with defaults and descriptions
- **main.tf**: Single `proxmox_virtual_environment_vm` resource with cloud-init
- **outputs.tf**: Exports vm_id, vm_name, and vm_ip (via ipv4_addresses[1][0])

### VM Creation Flow

1. Terraform clones from template (var.template_id, default 9000)
2. Cloud-init configures:
   - User account (var.vm_user, default "ubuntu")
   - SSH keys from secrets.tfvars
   - Network (DHCP or static based on var.vm_ip_address)
3. QEMU agent enabled but not pre-installed in template
4. Ansible installs agent and additional software post-creation

### Ansible Configuration

- **setup-proxmox-template.yml**: Creates Ubuntu 24.04 cloud-init template on Proxmox host
  - Downloads noble cloud image
  - Configures VM with cloud-init, serial console, QEMU agent enabled
  - Converts to template (ID 9000 by default)

- **install-qemu-agent.yml**: Installs qemu-guest-agent on running VMs
  - Runs on `proxmox_vms` inventory group
  - Uses apt to install and systemd to enable

### IP Address Resolution

Terraform outputs VM IP via `ipv4_addresses[1][0]` which requires QEMU guest agent. If agent isn't installed, this will show "Waiting for IP...". Use Ansible to install the agent, or check Proxmox console for IP.

## Important Notes

### Proxmox Template Requirements

The Ubuntu cloud-init template (default ID 9000) must exist before running Terraform:
- Created via `ansible/setup-proxmox-template.yml` playbook
- Or manually using commands in README.md
- Must have cloud-init enabled and QEMU agent configured (enabled=1)

### API Authentication

Provider uses token-based auth (not username/password):
```
api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
```
Format: `user@realm!tokenname=secret`

### Helper Scripts

Multiple shell scripts exist for template management and VM operations (cleanup-proxmox.sh, get-vm-ip.sh, etc.). These are convenience wrappers around qm commands and Ansible playbooks.
