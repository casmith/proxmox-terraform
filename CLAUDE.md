# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository manages multiple types of VMs on Proxmox using Terraform for infrastructure provisioning and Ansible for configuration management. The architecture is modular, allowing easy addition of new VM types (Ubuntu, Talos Linux, Windows, etc.).

## Tool Management

All development tools (Terraform, Ansible, Python) are managed via `mise`. Always prefix commands with `mise exec --` or activate mise in your shell.

## Common Commands

### Terraform Operations

```bash
# Initialize Terraform (required after cloning or adding modules)
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
mise exec -- terraform fmt -recursive
```

**Critical**: Always include `-var-file="secrets.tfvars"` when running plan/apply/destroy commands.

### Ansible Operations

```bash
# Create Ubuntu 24.04 template
ansible-playbook ansible/setup-proxmox-template.yml

# Create Talos Linux template
ansible-playbook ansible/setup-talos-template.yml

# Install QEMU guest agent on existing VMs (if needed)
ansible-playbook ansible/install-qemu-agent.yml

# Test connectivity
ansible proxmox_vms -m ping
```

### View Outputs

```bash
# All VMs grouped by type
terraform output all_vms

# Ubuntu VMs only
terraform output ubuntu_vm_details
terraform output ubuntu_vm_ips

# Talos VMs only
terraform output talos_vm_details
terraform output talos_vm_ips
```

## Architecture

### Modular Structure

The project uses a **module-based architecture** for scalability:

```
.
├── modules/
│   └── proxmox-vm/          # Reusable VM module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── vms-ubuntu.tf            # Ubuntu VM instances
├── vms-talos.tf             # Talos Linux VM instances
├── variables.tf             # All variable definitions
├── outputs.tf               # All outputs
├── versions.tf              # Provider configuration
└── ansible/
    ├── setup-proxmox-template.yml   # Ubuntu template
    └── setup-talos-template.yml     # Talos template
```

### Adding New VM Types

To add a new VM type (e.g., Windows, FreeBSD, OpenMediaVault):

1. **Create Ansible playbook**: `ansible/setup-{type}-template.yml`
   - Downloads OS image
   - Creates Proxmox template with unique ID
   - Configures cloud-init (if supported)

2. **Add variables**: In `variables.tf`, add:
   ```hcl
   variable "{type}_vm_count" { ... }
   variable "{type}_vm_name" { ... }
   variable "{type}_template_id" { ... }
   # etc.
   ```

3. **Create VM configuration**: `vms-{type}.tf`
   ```hcl
   module "{type}_vms" {
     source = "./modules/proxmox-vm"
     count  = var.{type}_vm_count > 0 ? 1 : 0
     # ... configuration
   }
   ```

4. **Add outputs**: In `outputs.tf`
   ```hcl
   output "{type}_vm_details" {
     value = try(module.{type}_vms[0].vm_details, {})
   }
   ```

### Two-File Variable System

Security-conscious variable configuration:

1. **secrets.tfvars** (gitignored): Sensitive data
   - Proxmox API token ID and secret
   - SSH public keys
   - Never committed to version control

2. **terraform.tfvars** (safe to commit): Non-sensitive configuration
   - VM counts, names, sizes
   - Network settings
   - Template references

### VM Module Features

The `modules/proxmox-vm` module supports:

- **Flexible cloud-init**: Automatic package installation, user creation, SSH keys
- **Custom configuration**: Override cloud-init entirely for special cases
- **QEMU agent**: Automatic IP detection when enabled
- **Multiple instances**: Use `vm_count` to create multiple VMs with auto-numbered names
- **Template cloning**: Clone from any Proxmox template ID

### Template Requirements

Templates must be created before running Terraform:
- **Ubuntu**: Template ID 9000 (via `setup-proxmox-template.yml`)
- **Talos**: Template ID 9001 (via `setup-talos-template.yml`)
- Must have cloud-init enabled and QEMU agent configured

### Provider Authentication

- **API**: Uses token-based auth (format: `user@realm!tokenname=secret`)
- **SSH**: Used for uploading cloud-init snippets to Proxmox host
  - Requires SSH access to Proxmox as configured user (default: root)
  - Uses local SSH agent for key management

### Cloud-Init Integration

The module generates cloud-init user-data that:
1. Creates user with SSH keys
2. Installs packages (qemu-guest-agent by default)
3. Runs custom commands
4. Stored as snippets in Proxmox `local` storage

## VM Configuration Examples

### Ubuntu VMs
```hcl
ubuntu_vm_count     = 2
ubuntu_vm_name      = "ubuntu-vm"
ubuntu_vm_cores     = 2
ubuntu_vm_memory    = 2048
ubuntu_vm_disk_size = 20
```
Creates: `ubuntu-vm-01`, `ubuntu-vm-02`

### Talos Linux VMs (Kubernetes)
```hcl
talos_vm_count     = 3
talos_vm_name      = "talos-k8s"
talos_vm_cores     = 4
talos_vm_memory    = 4096
talos_vm_disk_size = 50
```
Creates: `talos-k8s-01`, `talos-k8s-02`, `talos-k8s-03`

### Disable a VM Type
```hcl
ubuntu_vm_count = 0  # No Ubuntu VMs will be created
```

## IP Address Resolution

Terraform outputs VM IPs via QEMU guest agent (`ipv4_addresses[1][0]`). The agent is installed automatically via cloud-init on first boot. If "Waiting for IP..." appears:
- Wait 30-90 seconds for cloud-init to complete
- Check cloud-init status in VM console: `cloud-init status`
- Verify QEMU agent is running: `systemctl status qemu-guest-agent`

## Important Notes

### Snippets Storage

The `local` storage must support snippets. The Ansible playbooks automatically enable this:
```bash
pvesm set local --content vztmpl,iso,backup,snippets
```

### Module Count Pattern

Modules use `count = var.{type}_vm_count > 0 ? 1 : 0` to conditionally create resources. This prevents empty module instances when VM count is 0.

### State Management

After restructuring to modules, you may need to migrate existing state:
```bash
# Import existing VMs if needed
terraform import 'module.ubuntu_vms[0].proxmox_virtual_environment_vm.vm[0]' <vm-id>
```
