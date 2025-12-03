# Windows 11 Template Setup Guide

This guide explains how to create a Windows 11 template in Proxmox that works with Terraform and cloudbase-init.

## Prerequisites

1. Windows 11 ISO image
2. VirtIO drivers for Windows
3. Proxmox VE 7.0 or later
4. Sufficient storage space (60GB+ recommended)

## Quick Start

```bash
# 1. Download Windows 11 ISO manually and upload to Proxmox
# 2. Update the iso_file variable in setup-windows-template.yml
# 3. Run the playbook
ansible-playbook ansible/setup-windows-template.yml
```

## Detailed Steps

### Step 1: Obtain Windows 11 ISO

**Option A: Download from Microsoft (Recommended)**
1. Visit https://www.microsoft.com/software-download/windows11
2. Select "Download Windows 11 Disk Image (ISO)"
3. Choose your language and download

**Option B: Use Media Creation Tool**
1. Download Windows 11 Media Creation Tool
2. Create ISO file

### Step 2: Upload ISO to Proxmox

**Via Web UI:**
1. Navigate to: Datacenter → Storage (local) → ISO Images
2. Click "Upload"
3. Select your Windows 11 ISO

**Via CLI:**
```bash
# Copy ISO to Proxmox
scp Win11_23H2_English_x64.iso root@proxmox:/var/lib/vz/template/iso/
```

### Step 3: Update Playbook Variables

Edit `ansible/setup-windows-template.yml`:
```yaml
vars:
  iso_file: "Win11_23H2_English_x64.iso"  # Your ISO filename
```

### Step 4: Run Ansible Playbook

```bash
ansible-playbook ansible/setup-windows-template.yml
```

This creates the VM base and downloads VirtIO drivers automatically.

### Step 5: Install Windows 11

1. **Start the VM:**
   ```bash
   qm start 9002
   ```

2. **Connect via Proxmox VNC Console:**
   - Open Proxmox web UI
   - Navigate to VM 9002
   - Click "Console"

3. **Windows Installation:**
   - Select language and keyboard
   - Click "Install Now"
   - Enter product key or "I don't have a product key"
   - Select Windows 11 edition
   - Accept license terms

4. **Load VirtIO SCSI Driver:**
   - At "Where do you want to install Windows?" screen
   - Click "Load driver"
   - Click "Browse"
   - Navigate to: `D:\vioscsi\w11\amd64` (VirtIO CD)
   - Select "Red Hat VirtIO SCSI controller"
   - Click "Next"
   - Your disk should now appear
   - Select the disk and continue installation

5. **Complete Windows Setup:**
   - Follow Windows OOBE (Out of Box Experience)
   - Create a local account (recommended for templates)
   - Disable privacy settings for template

### Step 6: Install VirtIO Drivers

After Windows boots:

1. **Open File Explorer**
2. **Navigate to VirtIO CD drive** (usually D: or E:)
3. **Run:** `virtio-win-guest-tools.exe`
4. **Click through installer** with default settings
5. **Reboot** when prompted

This installs:
- Network drivers (netkvm)
- Balloon driver (memory management)
- QEMU Guest Agent
- Storage drivers
- Display drivers

### Step 7: Install cloudbase-init

cloudbase-init is the Windows equivalent of cloud-init:

1. **Download cloudbase-init:**
   - Visit: https://cloudbase.it/cloudbase-init
   - Download latest stable MSI (64-bit)

2. **Install cloudbase-init:**
   - Run the MSI installer
   - Use default settings
   - **Important:** Check these options:
     - ✅ Run Sysprep to create a generalized image
     - ✅ Shutdown when Sysprep finishes
   - Click "Finish"

3. **VM will run Sysprep and shutdown automatically**
   - This generalizes the Windows installation
   - Removes computer-specific information
   - Prepares for cloning

### Step 8: Convert to Template

After the VM shuts down:

```bash
# Convert to template
qm template 9002

# Optional: Remove installation ISOs to reduce template size
qm set 9002 --delete ide0  # Remove Windows ISO
qm set 9002 --delete ide3  # Remove VirtIO ISO
```

### Step 9: Verify Template

```bash
# Check template status
qm status 9002

# List template details
qm config 9002
```

## Template Features

Your Windows 11 template includes:

- ✅ **UEFI Boot** - Modern boot system
- ✅ **TPM 2.0** - Required for Windows 11
- ✅ **Secure Boot** - Pre-enrolled keys
- ✅ **VirtIO Drivers** - Optimized performance
- ✅ **QEMU Guest Agent** - IP detection and management
- ✅ **cloudbase-init** - Cloud-init for Windows
- ✅ **Cloud-init Drive** - Configuration injection

## Using with Terraform

Enable Windows VMs in `terraform.tfvars`:

```hcl
windows_vm_count     = 1
windows_vm_name      = "win11-vm"
windows_vm_cores     = 4
windows_vm_memory    = 8192
windows_vm_disk_size = 60
```

Apply with Terraform:

```bash
mise exec -- terraform plan -var-file="secrets.tfvars"
mise exec -- terraform apply -var-file="secrets.tfvars"
```

## Cloudbase-init Configuration

The Windows module uses cloud-init drives. cloudbase-init will:

1. Set hostname
2. Configure network (if static IP specified)
3. Create/configure user accounts
4. Set passwords
5. Run custom scripts
6. Enable RDP

## Troubleshooting

### Issue: Can't see disk during installation
**Solution:** Load VirtIO SCSI driver from VirtIO ISO

### Issue: No network after Windows installation
**Solution:** Install virtio-win-guest-tools.exe from VirtIO CD

### Issue: QEMU agent not working
**Solution:** Ensure virtio-win-guest-tools.exe was installed

### Issue: Cloud-init not working
**Solution:** Verify cloudbase-init was installed and Sysprep ran

### Issue: TPM 2.0 errors
**Solution:** Ensure Proxmox VE is 7.0 or later

### Issue: Windows activation
**Solution:** Use valid Windows license key or KMS activation

## Advanced Configuration

### Custom cloudbase-init Configuration

Default config location: `C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf`

You can customize:
- Metadata services
- Plugin execution order
- Network configuration
- User creation behavior

### Disk Expansion

Windows VMs will auto-expand disk if you increase size in Terraform:

```hcl
windows_vm_disk_size = 100  # Expands from 60GB to 100GB
```

cloudbase-init includes a disk expansion plugin by default.

## Security Considerations

1. **Windows Updates:** Run updates before creating template
2. **Activation:** Template should not be activated (will activate clones)
3. **User Accounts:** Use cloud-init to create users (don't bake passwords)
4. **RDP:** Will be enabled via cloud-init, ensure firewall rules
5. **Antivirus:** Consider installing on clones, not template

## Performance Tips

1. **VirtIO Drivers:** Essential for good I/O performance
2. **CPU Type:** Set to 'host' for best performance
3. **Memory:** Windows 11 needs minimum 4GB, 8GB recommended
4. **Disk:** Use local-lvm or SSD storage for best performance
5. **Balloon Driver:** Allows dynamic memory allocation

## Windows Licensing

Each cloned VM needs a valid Windows license. Options:

1. **Retail/OEM Keys:** One per VM
2. **Volume Licensing:** KMS or MAK activation
3. **Windows Server:** CAL licensing
4. **Evaluation:** 180-day trial (not for production)

Ensure compliance with Microsoft licensing terms.

## Next Steps

After template creation:

1. Test by creating a single VM
2. Verify QEMU agent reports IP address
3. Test RDP connectivity
4. Verify cloudbase-init configuration
5. Use Terraform to scale

## Resources

- [Proxmox Windows Guide](https://pve.proxmox.com/wiki/Windows_10_guest_best_practices)
- [cloudbase-init Documentation](https://cloudbase-init.readthedocs.io/)
- [VirtIO Drivers](https://github.com/virtio-win/virtio-win-pkg-scripts)
- [Windows 11 Requirements](https://www.microsoft.com/en-us/windows/windows-11-specifications)
