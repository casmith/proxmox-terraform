# Proxmox Cluster Setup Guide

This guide covers setting up a Proxmox cluster using Ansible for the initial cluster creation and node joining, while continuing to use Terraform for VM management.

## Architecture

- **Ansible**: One-time cluster bootstrap and configuration
- **Terraform**: Ongoing VM/container management across the cluster

This separation provides:
- Clean separation of concerns
- Idempotent cluster setup
- Terraform focused on what it does best (resource lifecycle)

## Prerequisites

### Secrets Configuration

**Root password must be stored in `secrets.yaml`** for automated cluster joining:

```bash
# Edit encrypted secrets
mise exec -- sops secrets.yaml

# Add this line:
proxmox_root_password: "your-root-password"
```

The Proxmox `pvecm add` command requires the root password as a security measure when joining nodes to a cluster. The playbook:
- Reads the password from encrypted `secrets.yaml`
- Automatically provides it during the join process
- Uses `no_log: true` to prevent password exposure in logs

### Network Requirements

1. **All nodes must be on the same network segment**
   - Example: 192.168.10.0/24
   - Low-latency network required for cluster communication

2. **SSH access between all nodes**
   - Root SSH access from your workstation to all nodes
   - SSH access between cluster nodes (for corosync)

3. **Firewall ports** (if firewall is enabled):
   - **5404-5412 UDP**: Corosync cluster communication
   - **22 TCP**: SSH
   - **8006 TCP**: Proxmox web interface
   - **3128 TCP**: SPICE proxy (optional)

### DNS/Hosts Requirements

Each node should be able to resolve other nodes by hostname. Options:

**Option 1**: Add entries to `/etc/hosts` on each node:
```bash
192.168.10.11 proxmox-01
192.168.10.9  proxmox-02
```

**Option 2**: Use proper DNS with forward and reverse zones

### Before You Begin

**WARNING**: Cluster creation will:
- Reset some Proxmox settings on joining nodes
- Require nodes to be relatively fresh (no existing cluster membership)
- Share configuration across all nodes

**Backup** any important VMs or configuration before proceeding.

## Inventory Configuration

The cluster node inventory is in `ansible/proxmox-inventory.ini`:

```ini
# Primary cluster node (first node to create the cluster)
[proxmox_cluster_primary]
proxmox-01 ansible_host=192.168.10.11 ansible_user=root

# Secondary cluster nodes (will join the cluster)
[proxmox_cluster_secondary]
proxmox-02 ansible_host=192.168.10.9 ansible_user=root
```

### Adding More Nodes

To add additional nodes to the cluster later:

1. **Add to inventory**:
   ```ini
   [proxmox_cluster_secondary]
   proxmox-02 ansible_host=192.168.10.9 ansible_user=root
   proxmox-03 ansible_host=192.168.10.13 ansible_user=root
   ```

2. **Run the playbook** (it will skip nodes already in cluster):
   ```bash
   ansible-playbook ansible/setup-proxmox-cluster.yml -i ansible/proxmox-inventory.ini
   ```

## Cluster Setup Steps

### 1. Verify Connectivity

Test SSH access to all nodes:

```bash
# Test primary node
ansible proxmox_cluster_primary -i ansible/proxmox-inventory.ini -m ping

# Test secondary nodes
ansible proxmox_cluster_secondary -i ansible/proxmox-inventory.ini -m ping

# Test all cluster nodes
ansible proxmox_cluster -i ansible/proxmox-inventory.ini -m ping
```

Expected output:
```
proxmox-01 | SUCCESS => {
    "ping": "pong"
}
proxmox-02 | SUCCESS => {
    "ping": "pong"
}
```

### 2. Create Cluster

Run the cluster setup playbook:

```bash
ansible-playbook ansible/setup-proxmox-cluster.yml -i ansible/proxmox-inventory.ini
```

The cluster name is set to "khaos" by default. You can customize it:

```bash
ansible-playbook ansible/setup-proxmox-cluster.yml \
  -i ansible/proxmox-inventory.ini \
  -e cluster_name="custom-name"
```

### What the Playbook Does

1. **On Primary Node**:
   - Checks if cluster already exists (idempotent)
   - Creates new cluster with `pvecm create`
   - Waits for cluster initialization
   - Verifies cluster status

2. **On Secondary Nodes** (one at a time):
   - Checks if node is already in a cluster
   - Verifies SSH connectivity to primary
   - Joins cluster with `pvecm add`
   - Waits for cluster sync
   - Verifies successful join

3. **Final Verification**:
   - Lists all cluster nodes
   - Shows cluster health status

### 3. Verify Cluster

After setup completes, verify on any node:

```bash
# SSH to any cluster node
ssh root@192.168.10.11

# Check cluster status
pvecm status

# List cluster nodes
pvecm nodes

# Check quorum status
pvecm expected 2  # Number of total nodes
```

Expected output from `pvecm status`:
```
Cluster information
-------------------
Name:             khaos
Config Version:   2
Transport:        knet
Secure auth:      on

Quorum information
------------------
Date:             ...
Quorum provider:  corosync_votequorum
Nodes:            2
Node ID:          0x00000001
Ring ID:          1.6
Quorate:          Yes
```

## Cluster Management

### Check Cluster Health

```bash
# Cluster status
pvecm status

# Node list
pvecm nodes

# Detailed cluster information
pvecm status --version

# Corosync configuration
cat /etc/pve/corosync.conf
```

### Node Operations

```bash
# Remove a node (run on a different node, not the one being removed)
pvecm delnode <nodename>

# Update cluster configuration (if needed)
pvecm updatecerts
```

### Quorum

For a 2-node cluster, you may want to adjust quorum settings:

```bash
# Set expected votes (for maintenance when a node is down)
pvecm expected 1

# Reset to normal
pvecm expected 2
```

**Note**: With only 2 nodes, losing one node loses quorum. Consider adding a third node or QDevice for production.

## Terraform Integration

### Single-Node vs Cluster Mode

Your Terraform configuration works with both:
- **Single node**: All VMs on one host
- **Cluster**: VMs can be distributed and migrated

### Cluster-Aware Features

Once clustered, you gain:

1. **High Availability (HA)**:
   ```hcl
   # Add to VM module
   ha {
     group   = "ha-group"
     enabled = true
   }
   ```

2. **Live Migration**: Move VMs between nodes without downtime

3. **Shared Storage**: Configure Ceph, NFS, or other shared storage

4. **Resource Pools**: Organize VMs across cluster

### Updating terraform.tfvars

No changes required! Terraform will automatically work with the cluster. However, you can now leverage cluster features:

```hcl
# Example: Specify target node for each VM
# (optional - Proxmox will auto-balance if not specified)
ubuntu_vm_target_node = "proxmox-01"
talos_vm_target_node  = "proxmox-02"
```

## Troubleshooting

### Cluster Creation Fails

**Issue**: `pvecm create` fails with "cluster already exists"

**Solution**:
```bash
# Check if node is in a cluster
pvecm status

# If old cluster config exists, remove it (DANGER: only if intentional)
systemctl stop pve-cluster corosync
pmxcfs -l
rm -rf /etc/pve/corosync.conf
rm -rf /etc/corosync/*
killall pmxcfs
systemctl start pve-cluster
```

### Node Cannot Join Cluster

**Issue**: `pvecm add` fails with connection errors

**Check**:
1. SSH connectivity: `ssh root@<primary-ip>`
2. Firewall: Ensure ports 5404-5412 UDP are open
3. Network: All nodes on same subnet
4. Time sync: `timedatectl status` (time must be synchronized)

### Cluster Shows "Not Quorate"

**Issue**: Cluster loses quorum after node failure

**2-node cluster fix**:
```bash
# Temporarily adjust expected votes (on remaining node)
pvecm expected 1

# When failed node returns, reset
pvecm expected 2
```

**Permanent solution**: Add a 3rd node or use a QDevice

### Split-Brain Prevention

With only 2 nodes, be careful with simultaneous failures. Best practices:
- Ensure reliable network between nodes
- Configure fencing/STONITH for production
- Consider adding a QDevice (quorum device) for proper split-brain prevention

## Next Steps

After cluster setup:

1. **Configure Shared Storage** (optional but recommended):
   - Ceph: Distributed storage across cluster
   - NFS: Network file system
   - iSCSI: Block-level storage

2. **Set Up High Availability**:
   - Define HA groups
   - Configure fencing
   - Set migration policies

3. **Configure Backups**:
   - Backup storage location
   - Backup schedules
   - Retention policies

4. **Update Terraform**:
   - No immediate changes needed
   - Can start using cluster features (HA, migration, etc.)

5. **Monitor Cluster**:
   - Set up monitoring (Prometheus, Grafana)
   - Configure alerts for node failures
   - Monitor corosync health

## References

- [Proxmox Cluster Manager (pvecm)](https://pve.proxmox.com/wiki/Cluster_Manager)
- [Corosync Documentation](https://pve.proxmox.com/wiki/Cluster_Manager#_corosync_configuration)
- [Proxmox HA Documentation](https://pve.proxmox.com/wiki/High_Availability)
- [QDevice Setup](https://pve.proxmox.com/wiki/Cluster_Manager#_corosync_external_vote_support)
