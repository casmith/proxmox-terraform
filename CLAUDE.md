# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository manages multiple types of VMs on Proxmox using Terraform for infrastructure provisioning and Ansible for configuration management. The architecture is modular, allowing easy addition of new VM types (Ubuntu, Talos Linux, Windows, etc.).

## Tool Management

All development tools (Terraform, Ansible, Python, SOPS) are managed via `mise`. Always prefix commands with `mise exec --` or activate mise in your shell.

## Secrets Management

Secrets are encrypted using [SOPS](https://github.com/getsops/sops) with age encryption and integrated into Terraform via the [carlpett/sops](https://registry.terraform.io/providers/carlpett/sops) provider. The `secrets.yaml` file is encrypted and safe to commit to git.

### Prerequisites

- **age key**: The private key file (`age.key`) must be present in the project root
  - This file is gitignored and must NOT be committed
  - Keep this file secure - it's required to decrypt secrets
  - Public key is configured in `.sops.yaml`
  - The `SOPS_AGE_KEY_FILE` environment variable is set globally in `mise.toml`

### Working with Encrypted Secrets

```bash
# Edit secrets directly (SOPS will decrypt, open editor, then re-encrypt automatically)
mise exec -- sops secrets.yaml

# View decrypted content without modifying file
mise exec -- sops --decrypt secrets.yaml
```

### How It Works

Terraform automatically decrypts `secrets.yaml` during plan/apply/destroy operations using the SOPS provider:

1. The `secrets.tf` file defines a `sops_file` data source that reads `secrets.yaml`
2. Secrets are decrypted in-memory (never written to disk unencrypted)
3. Values are accessed via `local.proxmox_api_token_id`, `local.proxmox_api_token_secret`, and `local.ssh_keys`
4. No manual decrypt/encrypt steps needed

**Important**: The `secrets.yaml` file remains encrypted at rest and is safe to commit to git.

## Common Commands

### Terraform Operations

```bash
# Initialize Terraform (required after cloning or adding modules)
mise exec -- terraform init

# Validate configuration
mise exec -- terraform validate

# Plan changes (preview)
mise exec -- terraform plan
# Or use the mise task: mise run tfplan

# Apply changes (create/update VMs)
mise exec -- terraform apply
# Or use the mise task: mise run tfapply

# Destroy infrastructure
mise exec -- terraform destroy
# Or use the mise task: mise run tfdestroy

# Format Terraform files
mise exec -- terraform fmt -recursive
```

**Note**: Secrets are automatically decrypted via the SOPS provider - no manual steps required.

### Ansible Operations

```bash
# Create Ubuntu 24.04 template
ansible-playbook ansible/setup-proxmox-template.yml

# Create Talos Linux template
ansible-playbook ansible/setup-talos-template.yml

# Create Windows 11 template (requires manual steps - see WINDOWS_SETUP_GUIDE.md)
ansible-playbook ansible/setup-windows-template.yml

# Create FreeBSD 15.0 template (requires manual steps - see FREEBSD_TEMPLATE_MANUAL_SETUP.md)
ansible-playbook ansible/setup-freebsd-template.yml

# Configure no-subscription repository (disables enterprise repo warning)
ansible-playbook ansible/configure-no-subscription-repo.yml

# Check if subscription popup was successfully disabled
ansible-playbook ansible/check-subscription-popup-status.yml

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

# Windows VMs only (when enabled)
terraform output windows_vm_details
terraform output windows_vm_ips

# FreeBSD VMs only
terraform output freebsd_vm_details
terraform output freebsd_vm_ips
```

## Architecture

### Modular Directory Structure

The project uses a **directory-based module architecture** for scalability. Each OS type has its own directory containing all its configuration:

```
.
├── main.tf                  # Root - orchestrates all OS modules
├── variables.tf             # Shared variables + OS-specific pass-throughs
├── outputs.tf               # Combined outputs from all OS modules
├── versions.tf              # Provider configuration
├── secrets.tf               # SOPS data source for encrypted secrets
├── secrets.yaml             # SOPS-encrypted secrets (safe to commit)
├── modules/
│   └── proxmox-vm/          # Reusable base VM module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── ubuntu/                  # Ubuntu VM configuration
│   ├── main.tf             # Ubuntu module definition
│   ├── variables.tf        # Ubuntu-specific variables
│   └── outputs.tf          # Ubuntu outputs
├── talos/                   # Talos Linux VM configuration
│   ├── main.tf             # Talos module definition
│   ├── variables.tf        # Talos-specific variables
│   └── outputs.tf          # Talos outputs
├── windows/                 # Windows VM configuration (template)
│   ├── main.tf             # Windows module definition
│   ├── variables.tf        # Windows-specific variables
│   └── outputs.tf          # Windows outputs
├── freebsd/                 # FreeBSD VM configuration
│   ├── main.tf             # FreeBSD module definition
│   ├── variables.tf        # FreeBSD-specific variables
│   └── outputs.tf          # FreeBSD outputs
└── ansible/
    ├── setup-proxmox-template.yml   # Ubuntu template
    ├── setup-talos-template.yml     # Talos template
    ├── setup-windows-template.yml   # Windows 11 template
    ├── setup-freebsd-template.yml   # FreeBSD template
    └── WINDOWS_SETUP_GUIDE.md       # Detailed Windows setup instructions
```

### Adding New VM Types

To add a new VM type (e.g., FreeBSD, OpenMediaVault), follow the Windows template structure:

1. **Create OS directory**: `mkdir {type}/`

2. **Create Ansible playbook**: `ansible/setup-{type}-template.yml`
   - Downloads OS image
   - Creates Proxmox template with unique ID
   - Configures cloud-init (if supported)

3. **Create module files in `{type}/` directory**:

   **`{type}/main.tf`**:
   ```hcl
   module "{type}_vms" {
     source = "../modules/proxmox-vm"
     count  = var.{type}_vm_count > 0 ? 1 : 0
     # ... configuration
   }
   ```

   **`{type}/variables.tf`**: Define OS-specific variables and shared variable inputs

   **`{type}/outputs.tf`**: Define module outputs

4. **Add to root `main.tf`**: Reference the new module
   ```hcl
   module "{type}" {
     source = "./{type}"
     # Pass shared and OS-specific variables
   }
   ```

5. **Add variables to root `variables.tf`**: Define OS-specific variables for pass-through

6. **Add outputs to root `outputs.tf`**:
   ```hcl
   output "{type}_vm_details" {
     value = module.{type}.vm_details
   }
   ```

### Secrets and Variables System

Security-conscious configuration:

1. **secrets.yaml** (encrypted with SOPS, safe to commit): Sensitive data
   - Proxmox API token ID and secret
   - SSH public keys
   - Encrypted at rest using age, decrypted automatically by Terraform
   - Accessed via `secrets.tf` data source and local values

2. **terraform.tfvars** (safe to commit): Non-sensitive configuration
   - VM counts, names, sizes
   - Network settings
   - Template references

### VM Module Features

The `modules/proxmox-vm` module supports:

- **Flexible cloud-init**: Automatic package installation, user creation, SSH keys
- **Custom configuration**: Override cloud-init entirely for special cases
- **QEMU agent**: Automatic IP detection when enabled
- **Cross-platform support**: Works with Linux (systemd) and BSD (rc.d) systems
  - Set `use_systemd_qemu_agent = false` for FreeBSD and other non-systemd OSes
- **Multiple instances**: Use `vm_count` to create multiple VMs with auto-numbered names
- **Template cloning**: Clone from any Proxmox template ID

### Template Requirements

Templates must be created before running Terraform:
- **Ubuntu**: Template ID 9000 (via `setup-proxmox-template.yml`)
- **Talos**: Template ID 9001 (via `setup-talos-template.yml`)
- **Windows**: Template ID 9002 (via `setup-windows-template.yml` - requires manual steps)
- **FreeBSD**: Template ID 114 (requires manual setup - see `FREEBSD_TEMPLATE_MANUAL_SETUP.md`)
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

### Windows VMs (Template)
```hcl
windows_vm_count     = 0  # Disabled by default (requires manual setup)
windows_vm_name      = "windows-vm"
windows_vm_cores     = 4
windows_vm_memory    = 8192
windows_vm_disk_size = 60
```
Creates: `windows-vm-01`, etc. (when template ID 9002 exists)

### FreeBSD VMs
```hcl
freebsd_vm_count     = 2
freebsd_vm_name      = "freebsd-vm"
freebsd_vm_cores     = 2
freebsd_vm_memory    = 2048
freebsd_vm_disk_size = 20
```
Creates: `freebsd-vm-01`, `freebsd-vm-02`

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

OS-specific modules in their directories use `count = var.{type}_vm_count > 0 ? 1 : 0` on the inner `proxmox-vm` module to conditionally create resources. This prevents empty module instances when VM count is 0.

### State Management

The reorganization into OS-specific directories may require state migration. To migrate existing resources:

```bash
# List current state
terraform state list

# Move resources to new module paths
# Example for Ubuntu VMs:
terraform state mv 'module.ubuntu_vms[0]' 'module.ubuntu.ubuntu_vms[0]'

# Example for Talos VMs:
terraform state mv 'module.talos_vms[0]' 'module.talos.talos_vms[0]'

# Verify with plan (should show no changes)
terraform plan
```

If starting fresh or importing VMs:
```bash
# Import existing VMs if needed
terraform import 'module.ubuntu.ubuntu_vms[0].proxmox_virtual_environment_vm.vm[0]' <vm-id>
```
