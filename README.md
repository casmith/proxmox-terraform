# Proxmox Terraform Configuration

This repository contains Terraform configuration to manage Ubuntu 24.04 VMs on Proxmox.

## Prerequisites

1. Proxmox VE server running and accessible
2. Terraform installed (managed via mise in this project)
3. Ubuntu 24.04 cloud-init template created in Proxmox
4. Proxmox API token created

## Setup Steps

### 1. Create Proxmox API Token

In the Proxmox web interface:
1. Navigate to Datacenter -> Permissions -> API Tokens
2. Click "Add"
3. Create a token with these settings:
   - User: `root@pam`
   - Token ID: `terraform`
   - Privilege Separation: Unchecked (for full permissions)
4. Save the token secret - you'll need it for terraform.tfvars

### 2. Create Ubuntu 24.04 Cloud-Init Template

You need a cloud-init enabled template to clone VMs from. Run these commands on your Proxmox server:

```bash
# Download Ubuntu 24.04 cloud image
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

# Create a VM (ID 9000 is just an example)
qm create 9000 --name ubuntu-2404-cloudinit-template --memory 2048 --net0 virtio,bridge=vmbr0 --cores 2

# Import the disk
qm importdisk 9000 noble-server-cloudimg-amd64.img local-lvm

# Attach the disk
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0

# Add cloud-init drive
qm set 9000 --ide2 local-lvm:cloudinit

# Set boot disk
qm set 9000 --boot c --bootdisk scsi0

# Add serial console
qm set 9000 --serial0 socket --vga serial0

# Enable QEMU guest agent
qm set 9000 --agent enabled=1

# Convert to template
qm template 9000
```

### 3. Configure Terraform Variables

This project separates secrets from configuration for better security:

1. **Copy and configure secrets** (NOT committed to git):
   ```bash
   cp secrets.tfvars.example secrets.tfvars
   ```
   Edit `secrets.tfvars` and add:
   - Proxmox API token ID and secret
   - Your SSH public key

2. **Edit VM configuration** (safe to commit):
   Edit `terraform.tfvars` to customize:
   - VM name, CPU, memory, disk size
   - Network configuration
   - Storage and template settings

### 4. Initialize and Apply Terraform

```bash
# Initialize Terraform (download providers)
mise exec -- terraform init

# Preview the changes (using both config and secrets)
mise exec -- terraform plan -var-file="secrets.tfvars"

# Create the VM
mise exec -- terraform apply -var-file="secrets.tfvars"

# When done, destroy the VM (optional)
mise exec -- terraform destroy -var-file="secrets.tfvars"
```

**Note**: Always include `-var-file="secrets.tfvars"` when running Terraform commands.

## Configuration Files

- `versions.tf` - Provider requirements and configuration
- `variables.tf` - Variable definitions with defaults
- `main.tf` - VM resource definition
- `outputs.tf` - Output values after VM creation
- `terraform.tfvars` - VM configuration (safe to commit)
- `secrets.tfvars` - API tokens and SSH keys (NOT committed to git)
- `secrets.tfvars.example` - Example secrets template

## Next Steps

After creating the VM with Terraform, you can use Ansible to configure it by:
1. Using the VM's IP address from Terraform outputs
2. Creating an Ansible inventory file
3. Running playbooks to install Docker and other tools
