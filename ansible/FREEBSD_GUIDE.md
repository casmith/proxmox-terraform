# FreeBSD Template Setup Guide

## Overview

FreeBSD provides official cloud images that work seamlessly with Proxmox and cloud-init, making template creation straightforward and automated.

## Quick Start

```bash
# Create FreeBSD 15.0 template (fully automated)
ansible-playbook ansible/setup-freebsd-template.yml
```

That's it! No manual steps required.

## What Gets Created

**Template ID:** 9003
**FreeBSD Version:** 15.0-RELEASE
**Template Features:**
- ✓ Official FreeBSD cloud image
- ✓ Cloud-init enabled
- ✓ VirtIO drivers (built into FreeBSD kernel)
- ✓ **QEMU Guest Agent (pre-installed and enabled)**
- ✓ Serial console configured
- ✓ Ready for immediate use with Terraform

**Default Resources:**
- CPU: 2 cores
- RAM: 2048 MB (2 GB)
- Disk: 20 GB

## How It Works

The Ansible playbook:

1. Downloads official FreeBSD 15.0 cloud image from FreeBSD servers
2. Extracts the compressed image
3. Creates a Proxmox VM (ID 9003)
4. Imports the FreeBSD disk
5. Configures VirtIO hardware
6. Adds cloud-init drive
7. Enables QEMU agent support
8. **Boots VM temporarily to pre-install QEMU agent**
9. **Shuts down VM after agent installation**
10. Converts to template
11. Cleans up temporary files

**Time:** ~7-8 minutes (includes 2-minute boot time for agent pre-installation)

## Using with Terraform

Enable FreeBSD VMs in `terraform.tfvars`:

```hcl
freebsd_vm_count     = 2
freebsd_vm_name      = "freebsd-vm"
freebsd_vm_cores     = 2
freebsd_vm_memory    = 2048
freebsd_vm_disk_size = 20
```

Apply with Terraform:

```bash
mise exec -- terraform apply -var-file="secrets.tfvars"
```

View results:

```bash
terraform output freebsd_vm_details
terraform output freebsd_vm_ips
```

## Pre-Installed QEMU Guest Agent

**Key Advantage:** Unlike the Ubuntu and Talos templates, this FreeBSD template has the QEMU Guest Agent **pre-installed and enabled**. This means:

✅ **Instant IP Detection:** VMs report their IP addresses immediately after boot
✅ **No Wait Time:** Terraform doesn't need to wait for cloud-init package installation
✅ **Faster Deployments:** VMs are ready ~30-60 seconds faster
✅ **More Reliable:** Agent is guaranteed to be present and configured

### How It Works

During template creation, the playbook:
1. Creates the base VM from FreeBSD cloud image
2. Uses cloud-init to install qemu-guest-agent package
3. **Loads virtio_console kernel module (CRITICAL for agent functionality)**
4. Enables the agent service with `sysrc`
5. Configures agent logging flags
6. Starts the agent to verify it works
7. Shuts down the VM cleanly
8. Converts to template with agent already installed

**Important:** FreeBSD requires the `virtio_console` kernel module for QEMU guest agent communication. This module must be loaded via `/boot/loader.conf` and is automatically configured during template creation.

When you clone this template via Terraform:
- Agent is already present in the VM
- Service is already enabled to start on boot
- No cloud-init installation step needed
- IP address available within 10-20 seconds of boot

## FreeBSD-Specific Features

### Package Management

FreeBSD uses `pkg` for package management. The template is configured to automatically install packages via cloud-init:

```yaml
cloud_init_packages:
  - qemu-guest-agent
  - vim
  - htop
```

### Service Management

FreeBSD uses `rc.d` for service management. The module automatically:

1. Installs qemu-guest-agent package
2. Enables the service: `sysrc qemu_guest_agent_enable=YES`
3. Starts the service: `service qemu-guest-agent start`

### Networking

FreeBSD network interfaces are named differently:
- `vtnet0` - VirtIO network interface (not `eth0`)
- Works with both DHCP and static IP configuration
- Cloud-init handles all network setup

### Filesystem

- Default filesystem: UFS (Unix File System)
- ZFS can be used but requires custom image
- Disk expansion supported via cloud-init

## Cloud-init Configuration

FreeBSD's cloud-init implementation supports:

- ✓ User creation
- ✓ SSH key injection
- ✓ Package installation
- ✓ Custom commands (runcmd)
- ✓ Hostname configuration
- ✓ Network configuration
- ✓ Disk resizing

Minor differences from Linux cloud-init:
- Package manager: `pkg` instead of `apt`/`yum`
- Service commands: `service` instead of `systemctl`
- Some advanced modules may not be available

## Use Cases for FreeBSD VMs

FreeBSD excels at:

1. **Networking:** Advanced networking features, firewall (pf), routing
2. **Storage:** ZFS filesystem with snapshots and replication
3. **Jails:** OS-level virtualization (like containers)
4. **Stability:** Production-grade stability and security
5. **Performance:** Excellent I/O performance
6. **Development:** Unix/BSD application development

## Version Information

**Current:** FreeBSD 15.0-RELEASE
**Architecture:** amd64 (x86_64)
**Image Type:** BASIC-CLOUDINIT-ufs
**Image Source:** https://download.freebsd.org/releases/VM-IMAGES/

To use a different version, edit `ansible/setup-freebsd-template.yml`:

```yaml
vars:
  freebsd_version: "14.2"  # Change version
  freebsd_release: "RELEASE"
  # Note: Update cloud_image_url filename as versions may use different naming schemes
```

Available versions:
- 15.0-RELEASE (current, recommended)
- 14.2-RELEASE (previous stable)
- 14.1-RELEASE (older stable)

## Troubleshooting

### Issue: Download fails
**Solution:** Check FreeBSD download servers are accessible, or use a mirror

### Issue: QEMU agent not reporting IP
**Solution:** The agent is pre-installed in the template and should work immediately. If not:
```bash
# Inside FreeBSD VM - check if service is running
service qemu-guest-agent status

# Check if virtio_console module is loaded (REQUIRED!)
kldstat | grep virtio_console

# If not loaded, load it immediately
kldload virtio_console

# Ensure it loads at boot
echo 'virtio_console_load="YES"' >> /boot/loader.conf

# Restart the agent after loading the module
service qemu-guest-agent restart
```

**Root Cause:** FreeBSD's QEMU guest agent requires the `virtio_console` kernel module for communication with the hypervisor. Without this module, the agent cannot send/receive data even if the service is running.

### Issue: SSH access denied
**Solution:** Ensure SSH keys are configured in `secrets.tfvars`

### Issue: Package installation fails
**Solution:** Check VM has internet access, FreeBSD pkg repositories are online

## Customization Examples

### Installing Additional Software

Edit `freebsd/main.tf`:

```hcl
cloud_init_packages = [
  "qemu-guest-agent",
  "nginx",
  "postgresql15-server",
  "git"
]
```

### Custom Startup Commands

```hcl
cloud_init_runcmd = [
  "sysrc qemu_guest_agent_enable=YES",
  "service qemu-guest-agent start",
  "sysrc nginx_enable=YES",
  "service nginx start"
]
```

### Using ZFS (requires custom image)

For ZFS support, you'll need to create a custom FreeBSD image or use one of the ZFS variants if available from FreeBSD.

## Comparison with Other OSes

| Feature | FreeBSD | Ubuntu | Windows |
|---------|---------|--------|---------|
| Setup Time | 5 min | 5 min | 30 min |
| Manual Steps | None | None | Many |
| Cloud-init | Yes | Yes | cloudbase-init |
| VirtIO Drivers | Built-in | Built-in | External |
| QEMU Agent | Package | Package | Installer |
| Automation | Full | Full | Partial |
| Resource Usage | Low | Low | High |

## Advanced: Multiple FreeBSD Versions

You can create multiple FreeBSD templates with different versions:

```bash
# Template 9003: FreeBSD 15.0
ansible-playbook setup-freebsd-template.yml

# Template 9004: FreeBSD 14.2 (edit playbook first)
# Change template_id: 9004 and freebsd_version: "14.2"
# Also update cloud_image_url to match the correct filename for 14.2
ansible-playbook setup-freebsd-template.yml
```

Then use different template IDs in Terraform:

```hcl
freebsd_template_id = 9003  # FreeBSD 15.0
# or
freebsd_template_id = 9004  # FreeBSD 14.2
```

## Resources

- [FreeBSD Official Site](https://www.freebsd.org/)
- [FreeBSD Cloud Images](https://www.freebsd.org/releases/)
- [FreeBSD Handbook](https://docs.freebsd.org/en/books/handbook/)
- [FreeBSD Cloud-init Documentation](https://docs.freebsd.org/en/books/handbook/virtualization/)
- [Proxmox FreeBSD Wiki](https://pve.proxmox.com/wiki/FreeBSD_as_Guest)

## Security Considerations

1. **Updates:** FreeBSD uses `freebsd-update` for system updates
   ```bash
   freebsd-update fetch install
   ```

2. **Packages:** Keep packages updated
   ```bash
   pkg update && pkg upgrade
   ```

3. **Firewall:** Configure pf (Packet Filter)
   ```bash
   sysrc pf_enable=YES
   service pf start
   ```

4. **SSH:** Disable password authentication, use keys only

5. **User Accounts:** Use cloud-init to create users, not manual accounts

## Performance Tips

1. **VirtIO:** Already configured for optimal I/O performance
2. **CPU Type:** Set to 'host' for best CPU performance (already done)
3. **Memory:** 2GB minimum, 4GB recommended for production
4. **Disk:** Use local-lvm or SSD storage
5. **Network:** VirtIO network driver provides excellent performance

## Next Steps

After creating the template:

1. Test by creating a single VM
2. Verify QEMU agent reports IP address
3. Test SSH connectivity
4. Verify package installation works
5. Scale with Terraform

## Why FreeBSD?

FreeBSD offers:

- **Stability:** Known for rock-solid reliability
- **Performance:** Excellent network and I/O performance
- **ZFS:** Advanced filesystem with snapshots and compression
- **Jails:** Lightweight OS-level virtualization
- **License:** Permissive BSD license
- **Documentation:** Comprehensive handbook and documentation
- **Security:** Strong security features and track record

Perfect for:
- Web servers
- Database servers
- Network appliances
- Development environments
- Learning Unix systems
