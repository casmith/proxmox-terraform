# Windows 11 Template - Quick Start

## Prerequisites Checklist

- [ ] Windows 11 ISO downloaded
- [ ] ISO uploaded to Proxmox (`/var/lib/vz/template/iso/`)
- [ ] Updated `iso_file` variable in `setup-windows-template.yml`

## Step-by-Step Commands

### 1. Run Ansible Playbook
```bash
ansible-playbook ansible/setup-windows-template.yml
```

### 2. Start VM and Install Windows
```bash
# Start the VM
qm start 9002

# Open Proxmox web UI → VM 9002 → Console
```

**During Windows Installation:**
- At disk selection screen: **Load driver** → Browse to `D:\vioscsi\w11\amd64`
- Install the Red Hat VirtIO SCSI controller
- Complete Windows installation with local account

### 3. Install Drivers (After First Boot)
```powershell
# Inside Windows VM:
# Navigate to VirtIO CD drive (D: or E:)
# Run: virtio-win-guest-tools.exe
# Install with defaults → Reboot
```

### 4. Install cloudbase-init
```powershell
# Download from: https://cloudbase.it/cloudbase-init
# Install the MSI
# ✅ Check: "Run Sysprep"
# ✅ Check: "Shutdown when complete"
# Click Finish → VM will shutdown automatically
```

### 5. Convert to Template
```bash
# After VM shuts down from Sysprep
qm template 9002

# Optional: Remove ISOs
qm set 9002 --delete ide0
qm set 9002 --delete ide3
```

## Enable in Terraform

Edit `terraform.tfvars`:
```hcl
windows_vm_count = 1
```

Apply:
```bash
mise exec -- terraform apply -var-file="secrets.tfvars"
```

## Verification

```bash
# Check template exists
qm status 9002

# Check VM created by Terraform
terraform output windows_vm_details
terraform output windows_vm_ips
```

## Troubleshooting Quick Fixes

| Problem | Solution |
|---------|----------|
| Can't see disk | Load VirtIO SCSI driver during installation |
| No network | Install virtio-win-guest-tools.exe |
| No IP in Terraform | Wait 2-3 minutes for cloudbase-init, check QEMU agent |
| TPM error | Ensure Proxmox VE 7.0+ |

## Time Estimates

- Ansible playbook: ~5 minutes
- Windows installation: ~15 minutes
- Driver installation: ~5 minutes
- cloudbase-init + Sysprep: ~5 minutes
- **Total: ~30 minutes**

## What Gets Installed

| Component | Purpose |
|-----------|---------|
| VirtIO SCSI | Disk controller driver |
| VirtIO Network | Network adapter driver |
| Balloon Driver | Memory management |
| QEMU Guest Agent | IP detection & management |
| cloudbase-init | Windows cloud-init equivalent |

## Next VM Types

To add more OS types (FreeBSD, OpenMediaVault, etc.):
1. Copy `windows/` directory: `cp -r windows/ {newos}/`
2. Create template playbook: `ansible/setup-{newos}-template.yml`
3. Update root `main.tf`, `variables.tf`, and `outputs.tf`

See `CLAUDE.md` for detailed instructions.
