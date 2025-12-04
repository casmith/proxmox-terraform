# FreeBSD Template Manual Setup Guide

## The Problem

FreeBSD BASIC-CLOUDINIT images use a **minimal cloud-init implementation** (`bsd-cloudinit` or `nuageinit`) that:
- Does **NOT** support the `packages` directive
- Has very limited `runcmd` support
- Does **NOT** come with full cloud-init pre-installed
- Does **NOT** come with qemu-guest-agent pre-installed
- Does **NOT** enable SSH by default

This means automated template creation doesn't work reliably. **Manual setup is required.**

## Manual Template Creation Steps

### Step 1: Download and Create Base VM

Run the Ansible playbook to create the base VM (it won't fully configure it, but will create the structure):

```bash
ansible-playbook ansible/setup-freebsd-template.yml
```

Or manually via Proxmox CLI:

```bash
# Download FreeBSD image
cd /tmp
wget https://download.freebsd.org/releases/VM-IMAGES/15.0-RELEASE/amd64/Latest/FreeBSD-15.0-RELEASE-amd64-BASIC-CLOUDINIT-ufs.raw.xz
xz -d FreeBSD-15.0-RELEASE-amd64-BASIC-CLOUDINIT-ufs.raw.xz

# Create VM (using ID 114)
qm create 114 --name freebsd-15-template --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0 --ostype other

# Import disk
qm importdisk 114 /tmp/FreeBSD-15.0-RELEASE-amd64-BASIC-CLOUDINIT-ufs.raw local-lvm

# Configure VM
qm set 114 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-114-disk-0
qm set 114 --ide2 local-lvm:cloudinit
qm set 114 --boot order=scsi0
qm set 114 --serial0 socket --vga serial0
qm set 114 --agent enabled=1
qm set 114 --cpu host
```

### Step 2: Start the VM

```bash
qm start 114
```

### Step 3: Access the Console

1. Open Proxmox web UI
2. Click on VM 114
3. Click **Console**
4. Wait for FreeBSD to boot (may take 1-2 minutes)

### Step 4: Log In

- **Username**: `freebsd` (default user in BASIC-CLOUDINIT images)
- **Password**: You may need to use the console to set a password first, or log in as root

If you can't log in as `freebsd`, press Enter a few times and you should see a login prompt. Try:
- Username: `freebsd`
- If that doesn't work, try: `root` (no password on first boot)

### Step 5: Install Required Packages

Once logged in, run these commands:

```bash
# Switch to root if needed
sudo su -

# Bootstrap pkg system (required on first use)
env ASSUME_ALWAYS_YES=YES pkg bootstrap

# Install required packages
pkg install -y qemu-guest-agent py311-cloud-init sudo bash

# Verify installation
pkg info | grep -E 'qemu-guest-agent|cloud-init'
```

### Step 6: Configure Services

```bash
# Enable SSH server
sysrc sshd_enable="YES"

# Enable cloud-init
sysrc cloudinit_enable="YES"

# Enable QEMU guest agent
sysrc qemu_guest_agent_enable="YES"
sysrc qemu_guest_agent_flags="-d -v -l /var/log/qemu-ga.log"

# Configure virtio_console kernel module (required for QEMU agent)
echo 'virtio_console_load="YES"' >> /boot/loader.conf
kldload virtio_console

# Start services immediately
service sshd start
service qemu-guest-agent start
```

### Step 7: Verify Services Are Running

```bash
# Check SSH
service sshd status

# Check QEMU guest agent
service qemu-guest-agent status

# Both should show "is running"
```

### Step 8: Clean Up and Shutdown

```bash
# Optional: Clear any temporary cloud-init data
rm -rf /var/lib/cloud/*
rm -rf /var/log/cloud-init*

# Shutdown the VM
shutdown -p now
```

### Step 9: Convert to Template

Wait for the VM to fully shutdown, then:

```bash
# Remove any custom cloud-init config
qm set 114 --delete cicustom

# Convert to template
qm template 114
```

### Step 10: Clean Up Downloads

```bash
rm -f /tmp/FreeBSD-15.0-RELEASE-amd64-BASIC-CLOUDINIT-ufs.raw*
rm -f /var/lib/vz/snippets/freebsd-template-init.yml
```

## Verification

After creating the template, test it by creating a VM with Terraform:

```bash
# In terraform.tfvars, set:
freebsd_vm_count = 1

# Apply
mise exec -- terraform apply -var-file="secrets.tfvars"

# Check if IP is reported (may take 30-60 seconds)
mise exec -- terraform output freebsd_vm_ips

# SSH into the VM
ssh freebsd@<IP_ADDRESS>
```

## What the Template Now Includes

- ✅ Full cloud-init support (py311-cloud-init package)
- ✅ QEMU guest agent installed and configured
- ✅ SSH server enabled by default
- ✅ virtio_console kernel module loaded
- ✅ All services configured to start on boot

## Troubleshooting

### Can't log in as freebsd user

Try logging in as `root` (no password initially). The BASIC-CLOUDINIT images may not create the `freebsd` user until cloud-init runs.

### "pkg: not found"

Run: `env ASSUME_ALWAYS_YES=YES pkg bootstrap` to initialize the pkg system.

### QEMU agent not communicating

1. Check if virtio_console is loaded: `kldstat | grep virtio`
2. Check agent status: `service qemu-guest-agent status`
3. Check agent log: `tail -f /var/log/qemu-ga.log`

### Cloud-init not running

Check `/var/log/cloud-init.log` and `/var/log/cloud-init-output.log` for errors.

## Sources

- [Using cloud-init on FreeBSD](https://people.freebsd.org/~dch/posts/2024-07-25-cloudinit/)
- [FreeBSD Cloud-Init Forums](https://forums.freebsd.org/threads/setup-cloud-init-freebsd-14-1basic-cloudinit-network-troubleshooting.94047/)
- [FreeBSD as a Tier 1 cloud-init Platform](https://www.freebsd.org/status/report-2024-01-2024-03/cloud-init/)
