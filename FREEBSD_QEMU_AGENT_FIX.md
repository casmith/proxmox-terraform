# FreeBSD VM Configuration Fix

## The Problems

FreeBSD VMs had two critical issues:

1. **SSH was not accessible** - couldn't log in to the VMs
2. **IP addresses not reported** - QEMU guest agent wasn't starting

## Root Causes

### Problem 1: SSH Not Enabled

**FreeBSD cloud-init images do not enable SSH by default.** Unlike Ubuntu cloud images where SSH is enabled automatically, FreeBSD requires explicit configuration to enable the `sshd` service via cloud-init.

### Problem 2: Wrong Service Management Commands

The base VM module (`modules/proxmox-vm`) was using **Linux-specific systemd commands** to start the QEMU agent:

```yaml
runcmd:
  - systemctl start qemu-guest-agent
  - systemctl enable qemu-guest-agent
```

**FreeBSD doesn't use systemd** - it uses the traditional BSD `rc.d` system with the `service` command and `/etc/rc.conf` for service management.

When cloud-init tried to run these commands on FreeBSD:
- `systemctl` commands failed (command not found)
- Even though the FreeBSD module added correct BSD commands in `cloud_init_runcmd`, the systemctl commands were also being injected
- The agent package was installed but the service never started

### Problem 3: Linux-Specific User Configuration

The base module also had Linux-specific user configuration:
- `groups: sudo` (FreeBSD uses `wheel`, not `sudo`)
- `shell: /bin/bash` (FreeBSD default shell is `/bin/sh` or `/bin/csh`)

## The Solution

### Solution 1: Custom Cloud-Init for FreeBSD

Created a FreeBSD-specific cloud-init configuration that:
- Uses `wheel` group instead of `sudo`
- Uses `/bin/sh` shell
- **Enables and starts the SSH service** (critical!)
- Uses BSD service management commands

### Solution 2: Conditional systemd Commands

Added a new variable `use_systemd_qemu_agent` to the base VM module:

**`modules/proxmox-vm/variables.tf`**:
```hcl
variable "use_systemd_qemu_agent" {
  description = "Use systemd commands to start QEMU agent (set to false for FreeBSD/non-systemd OSes)"
  type        = bool
  default     = true
}
```

**`modules/proxmox-vm/main.tf`**:
```hcl
runcmd:
%{if var.enable_qemu_agent && var.use_systemd_qemu_agent~}
  - systemctl start qemu-guest-agent
  - systemctl enable qemu-guest-agent
%{endif~}
```

**`freebsd/main.tf`**:
```hcl
module "freebsd_vms" {
  # ...
  enable_qemu_agent      = true
  use_systemd_qemu_agent = false  # FreeBSD uses rc.d, not systemd

  # Custom cloud-init with FreeBSD-specific configuration
  custom_cloud_init = <<-EOF
  #cloud-config
  users:
    - name: ${var.freebsd_vm_user}
      ssh_authorized_keys:
        - ${trimspace(var.ssh_keys)}
      groups: wheel
      shell: /bin/sh
      sudo: ALL=(ALL) NOPASSWD:ALL

  runcmd:
    # Enable and start SSH server (CRITICAL!)
    - sysrc sshd_enable="YES"
    - service sshd start
    # Configure virtio console for QEMU agent
    - echo 'virtio_console_load="YES"' >> /boot/loader.conf
    - kldload virtio_console || true
    # Enable and start QEMU guest agent
    - sysrc qemu_guest_agent_enable="YES"
    - sysrc qemu_guest_agent_flags="-d -v -l /var/log/qemu-ga.log"
    - service qemu-guest-agent restart || service qemu-guest-agent start
  EOF
}
```

## How to Apply the Fix

### For Existing FreeBSD VMs

You have two options:

**Option 1: Recreate VMs (clean slate)**
```bash
# Destroy existing FreeBSD VMs
mise exec -- terraform destroy -target='module.freebsd' -var-file="secrets.tfvars"

# Apply with the fix
mise exec -- terraform apply -var-file="secrets.tfvars"
```

**Option 2: Manually fix existing VMs**

You'll need to use the Proxmox console since SSH isn't working yet:

1. Open the VM console in Proxmox web UI
2. Log in as `freebsd` (you may need to set a password first using the console)
3. Run these commands:

```bash
# Enable and start SSH (CRITICAL!)
sudo sysrc sshd_enable="YES"
sudo service sshd start

# Install QEMU guest agent (if not already installed)
sudo pkg install -y qemu-guest-agent

# Load virtio_console kernel module
sudo kldload virtio_console
echo 'virtio_console_load="YES"' | sudo tee -a /boot/loader.conf

# Enable and start the agent
sudo sysrc qemu_guest_agent_enable="YES"
sudo sysrc qemu_guest_agent_flags="-d -v -l /var/log/qemu-ga.log"
sudo service qemu-guest-agent start
```

Now SSH should work:
```bash
ssh freebsd@<VM_IP_ADDRESS>
```

### For New FreeBSD VMs

Just apply normally - the fix is already in place:
```bash
mise exec -- terraform apply -var-file="secrets.tfvars"
```

## Verification

After applying the fix, check that IPs are being reported:

```bash
# View FreeBSD VM details
mise exec -- terraform output freebsd_vm_details

# View just the IPs
mise exec -- terraform output freebsd_vm_ips
```

You should see actual IP addresses instead of "Waiting for IP...".

## Technical Details

### FreeBSD Service Management vs Linux

| Aspect | Linux (systemd) | FreeBSD (rc.d) |
|--------|----------------|----------------|
| Command | `systemctl` | `service` |
| Config file | `/etc/systemd/system/` | `/etc/rc.conf` |
| Enable service | `systemctl enable` | `sysrc service_enable="YES"` |
| Start service | `systemctl start` | `service start` |
| Status | `systemctl status` | `service status` |

### VirtIO Console Requirement

FreeBSD requires the `virtio_console` kernel module for proper communication between the QEMU agent and the hypervisor:

```bash
# Load immediately
kldload virtio_console

# Load on boot
echo 'virtio_console_load="YES"' >> /boot/loader.conf
```

Without this module, the agent can't communicate with Proxmox even if it's running.

## Other Non-Systemd OSes

This fix applies to any non-systemd operating system:
- OpenBSD
- NetBSD
- Alpine Linux (uses OpenRC)
- Gentoo (can use OpenRC)
- Void Linux (uses runit)

For these systems, set `use_systemd_qemu_agent = false` and provide OS-appropriate startup commands in `custom_cloud_init` or `cloud_init_runcmd`.

## Sources

Information based on FreeBSD cloud-init documentation and community experience:
- [FreeBSD Cloud-Init Forums - BASIC-CLOUDINIT Setup](https://forums.freebsd.org/threads/setup-cloud-init-freebsd-14-1basic-cloudinit-network-troubleshooting.94047/)
- [Using Cloud-init with FreeBSD - Shapehost](https://shape.host/resources/using-cloud-init-with-freebsd-in-cloud-environments)
- [Proxmox Cloud-Init with FreeBSD](https://forums.freebsd.org/threads/proxmox-cloud-init-initialization-using-freebsd-vm-qcow2-image.85037/)
- [Preparing a FreeBSD Cloud Image with Cloud-Init](https://community.ops.io/jmarhee/preparing-a-freebsd-cloud-image-with-cloud-init-22lh)
