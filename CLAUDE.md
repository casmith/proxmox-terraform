# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository manages multiple types of VMs on Proxmox using Terraform for infrastructure provisioning and Ansible for configuration management. The architecture is modular, allowing easy addition of new VM types (Ubuntu, Talos Linux, Windows, etc.).

**Cluster Support**: Ansible handles one-time Proxmox cluster creation and node joining (see `PROXMOX_CLUSTER_SETUP.md`), while Terraform continues to manage VMs across the cluster.

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

## Remote State Backend

Terraform state is stored remotely in an S3-compatible backend at `s3.kalde.in`. This enables team collaboration and prevents state conflicts.

### Backend Configuration

The S3 backend is configured in `versions.tf`:
- **Bucket**: `terraform-state`
- **Key**: `proxmox/terraform.tfstate`
- **Endpoint**: `https://s3.kalde.in`

S3 credentials are stored in the encrypted `secrets.yaml` file and automatically loaded when running Terraform commands via mise tasks.

### Working with Remote State

**Recommended**: Use mise tasks which automatically handle S3 credentials:
```bash
# Initialize (required after cloning or backend changes)
mise run tfinit

# Plan changes
mise run tfplan

# Apply changes
mise run tfapply

# Destroy infrastructure
mise run tfdestroy
```

**Advanced**: Run terraform commands directly with credentials:
```bash
export AWS_ACCESS_KEY_ID=$(mise exec -- sops --decrypt secrets.yaml | grep 's3_access_key:' | awk '{print $2}')
export AWS_SECRET_ACCESS_KEY=$(mise exec -- sops --decrypt secrets.yaml | grep 's3_secret_key:' | awk '{print $2}')
mise exec -- terraform <command>
```

**Important**: The mise tasks in `mise.toml` automatically export AWS credentials from the encrypted secrets file before running Terraform commands.

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
# === TEMPLATE CREATION ===

# Create ALL templates on ALL nodes (recommended)
ansible-playbook ansible/setup-all-templates.yml -i ansible/proxmox-inventory.ini

# Or create templates individually per node:

# Create Ubuntu template on pve1 (ID 9000)
ansible-playbook ansible/setup-ubuntu2404-template.yml -e target_hosts=proxmox-01

# Create Talos template on pve1 (ID 9001)
ansible-playbook ansible/setup-talos-template.yml -e target_hosts=proxmox-01

# Create Ubuntu template on pve2 (ID 9100)
ansible-playbook ansible/setup-ubuntu2404-template.yml -e target_hosts=proxmox-02 -e ubuntu_template_id=9100

# Create Talos template on pve2 (ID 9101)
ansible-playbook ansible/setup-talos-template.yml -e target_hosts=proxmox-02 -e talos_template_id=9101

# Create Windows 11 template (requires manual steps - see WINDOWS_SETUP_GUIDE.md)
ansible-playbook ansible/setup-windows-template.yml

# Create FreeBSD 15.0 template (requires manual steps - see FREEBSD_TEMPLATE_MANUAL_SETUP.md)
ansible-playbook ansible/setup-freebsd-template.yml

# === CLUSTER SETUP (if using multiple nodes) ===

# 1. Create Proxmox cluster and join nodes (see PROXMOX_CLUSTER_SETUP.md)
ansible-playbook ansible/setup-proxmox-cluster.yml -i ansible/proxmox-inventory.ini

# 2. Set up NFS shared storage (for VM data, not templates)
ansible-playbook ansible/setup-nfs-storage.yml -i ansible/proxmox-inventory.ini

# === END CLUSTER SETUP ===

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
# All VMs grouped by node
terraform output all_vms_by_node

# pve1 VMs
terraform output pve1_all_vms
terraform output pve1_ubuntu_vm_details
terraform output pve1_ubuntu_vm_ips
terraform output pve1_talos_vm_details
terraform output pve1_talos_vm_ips
terraform output pve1_talos_sandbox_vm_details
terraform output pve1_talos_sandbox_vm_ips

# pve2 VMs
terraform output pve2_all_vms
terraform output pve2_ubuntu_vm_details
terraform output pve2_ubuntu_vm_ips
terraform output pve2_talos_vm_details
terraform output pve2_talos_vm_ips
terraform output pve2_talos_sandbox_vm_details
terraform output pve2_talos_sandbox_vm_ips

# All VMs of a specific type across all nodes
terraform output all_ubuntu_vms
terraform output all_talos_vms
terraform output all_talos_sandbox_vms

# All VM IPs across all nodes
terraform output all_vm_ips
```

## Architecture

### Node-Based Directory Structure

The project uses a **node-based module architecture** for multi-node Proxmox clusters. Each node has its own directory containing all VM configurations and template IDs for that node:

```
.
├── main.tf                    # Root - orchestrates node modules
├── variables.tf               # Node-prefixed variables (pve1_, pve2_)
├── outputs.tf                 # Combined outputs from all nodes
├── terraform.tfvars           # VM counts and config per node
├── versions.tf                # Provider configuration
├── secrets.tf                 # SOPS data source for encrypted secrets
├── secrets.yaml               # SOPS-encrypted secrets (safe to commit)
├── modules/
│   └── proxmox-vm/            # Reusable base VM module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── nodes/
│   ├── pve1/                  # pve1 node configuration
│   │   ├── main.tf           # All VMs for pve1 (ubuntu, talos, etc.)
│   │   ├── variables.tf      # Pass-through variables
│   │   ├── outputs.tf        # pve1 outputs
│   │   └── terraform.tfvars  # pve1-specific config (template IDs: 9000, 9001)
│   └── pve2/                  # pve2 node configuration
│       ├── main.tf           # All VMs for pve2 (ubuntu, talos, etc.)
│       ├── variables.tf      # Pass-through variables
│       ├── outputs.tf        # pve2 outputs
│       └── terraform.tfvars  # pve2-specific config (template IDs: 9100, 9101)
└── ansible/
    ├── setup-all-templates.yml      # Creates all templates on all nodes
    ├── setup-ubuntu2404-template.yml # Ubuntu template (per-node)
    ├── setup-talos-template.yml      # Talos template (per-node)
    ├── setup-windows-template.yml    # Windows template
    └── setup-freebsd-template.yml    # FreeBSD template
```

### Adding New Nodes

To add a new node (e.g., pve3):

1. **Create node directory**: `mkdir nodes/pve3`

2. **Copy configuration from existing node**:
   ```bash
   cp nodes/pve1/* nodes/pve3/
   sed -i 's/pve1/pve3/g' nodes/pve3/*.tf
   ```

3. **Update `nodes/pve3/terraform.tfvars`** with node-specific template IDs:
   ```hcl
   proxmox_node = "pve3"
   ubuntu_template_id = 9200  # Increment by 100 per node
   talos_template_id  = 9201
   ```

4. **Add to root `main.tf`**:
   ```hcl
   module "pve3" {
     source = "./nodes/pve3"
     # ... configuration
   }
   ```

5. **Add to root `variables.tf`**: Define pve3_ prefixed variables

6. **Add to root `terraform.tfvars`**: Configure VMs for pve3

7. **Update `ansible/setup-all-templates.yml`**: Add pve3 to template ID mappings

### Adding New VM Types

To add a new VM type to all nodes (e.g., Rocky Linux):

1. **Update each node's `main.tf`**: Add a new module block for the new VM type

2. **Update `nodes/*/variables.tf`**: Add variables for the new VM type

3. **Update `nodes/*/terraform.tfvars`**: Configure template ID and VM settings

4. **Update root `variables.tf`**: Add node-prefixed variables (pve1_rocky_*, pve2_rocky_*)

5. **Update root `terraform.tfvars`**: Configure VMs per node

6. **Create Ansible playbook**: `ansible/setup-rocky-template.yml` or add to unified playbook
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

**Per-Node Template Architecture:**

Templates are stored on local-lvm storage on each node for performance and reliability. Each node has its own set of templates with unique IDs:

**Template ID Schema:**
- **pve1**: Ubuntu=9000, Talos=9001, Windows=9002
- **pve2**: Ubuntu=9100, Talos=9101, Windows=9102
- **Future nodes**: Increment by 100 per node (pve3 would use 9200, 9201, etc.)

**Creating Templates:**

```bash
# Create Ubuntu template on pve1 (ID 9000)
ansible-playbook ansible/setup-ubuntu2404-template.yml -e target_hosts=proxmox-01

# Create Talos template on pve1 (ID 9001)
ansible-playbook ansible/setup-talos-template.yml -e target_hosts=proxmox-01

# Create Ubuntu template on pve2 (ID 9100)
ansible-playbook ansible/setup-ubuntu2404-template.yml -e target_hosts=proxmox-02 -e ubuntu_template_id=9100

# Create Talos template on pve2 (ID 9101)
ansible-playbook ansible/setup-talos-template.yml -e target_hosts=proxmox-02 -e talos_template_id=9101
```

**Why Per-Node Templates?**
- **Performance**: Local-lvm cloning is faster than NFS-based cloning
- **Reliability**: No dependency on shared storage for VM provisioning
- **Boot stability**: Cloning from local storage to local storage prevents boot issues

**Note**: VMs clone from templates on the same node. Cross-node cloning is not supported when using local-lvm storage.

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

Configuration is done per-node in `terraform.tfvars`:

### Ubuntu VMs on pve1
```hcl
# In terraform.tfvars
pve1_ubuntu_vm_count     = 2
pve1_ubuntu_vm_name      = "ubuntu-vm"
pve1_ubuntu_vm_cores     = 2
pve1_ubuntu_vm_memory    = 2048
pve1_ubuntu_vm_disk_size = 20
```
Creates: `ubuntu-vm-01`, `ubuntu-vm-02` on pve1 (using template 9000)

### Talos Linux VMs on pve1 (Kubernetes)
```hcl
# In terraform.tfvars
pve1_talos_vm_count     = 3
pve1_talos_vm_name      = "talos-k8s"
pve1_talos_vm_cores     = 4
pve1_talos_vm_memory    = 4096
pve1_talos_vm_disk_size = 50
```
Creates: `talos-k8s-01`, `talos-k8s-02`, `talos-k8s-03` on pve1 (using template 9001)

### Talos Sandbox VMs on pve2
```hcl
# In terraform.tfvars
pve2_talos_sandbox_vm_count         = 2
pve2_talos_sandbox_vm_name          = "talos-sandbox-pve2"
pve2_talos_sandbox_vm_cores         = 4
pve2_talos_sandbox_vm_memory        = 4096
pve2_talos_sandbox_vm_mac_addresses = ["BC:24:11:42:4E:F3", "BC:24:11:B2:0B:F7"]
```
Creates: `talos-sandbox-pve2-01`, `talos-sandbox-pve2-02` on pve2 (using template 9101)

### Disable VMs on a specific node
```hcl
# In terraform.tfvars
pve2_ubuntu_vm_count = 0  # No Ubuntu VMs on pve2
pve1_windows_vm_count = 0  # No Windows VMs on pve1
```

### Distribute VMs across nodes
```hcl
# In terraform.tfvars
# 2 Ubuntu VMs on pve1, 3 Ubuntu VMs on pve2
pve1_ubuntu_vm_count = 2
pve2_ubuntu_vm_count = 3

# 3 Talos VMs on pve1, 2 Talos VMs on pve2
pve1_talos_vm_count = 3
pve2_talos_vm_count = 2
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
