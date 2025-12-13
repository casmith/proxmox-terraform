# Proposal: Support Manual VM Migration Without Drift

## Problem
We want to:
1. Specify initial node placement for VMs in Terraform
2. Allow manual live migration between cluster nodes via Proxmox UI
3. Prevent Terraform from detecting this as drift and trying to "fix" it
4. Still allow Terraform to destroy migrated VMs

## Solution
Add `ignore_changes` lifecycle rule for `node_name` attribute in the VM module.

## Implementation

### Option A: Ignore node drift for all VMs (recommended)
Add to `modules/proxmox-vm/main.tf`:

```hcl
resource "proxmox_virtual_environment_vm" "vm" {
  count     = var.vm_count
  name      = var.vm_count > 1 ? "${var.vm_name}-${format("%02d", count.index + 1)}" : var.vm_name
  node_name = var.proxmox_node
  tags      = split(";", var.vm_tags)
  on_boot   = true
  started   = true

  timeout_shutdown_vm = 300

  lifecycle {
    ignore_changes = [node_name]  # Allow manual migration without Terraform drift
  }

  clone {
    # ... rest of config
  }
  # ... rest of resource
}
```

### Option B: Make it configurable per module
Add a variable to control this behavior:

In `modules/proxmox-vm/variables.tf`:
```hcl
variable "ignore_node_migration" {
  description = "Ignore manual VM migrations (allow VMs to move without Terraform drift)"
  type        = bool
  default     = true
}
```

In `modules/proxmox-vm/main.tf`:
```hcl
resource "proxmox_virtual_environment_vm" "vm" {
  # ... configuration ...

  dynamic "lifecycle" {
    for_each = var.ignore_node_migration ? [1] : []
    content {
      ignore_changes = [node_name]
    }
  }
}
```

## How It Works

### Initial Creation
```bash
# main.tf specifies:
proxmox_node = "pve1"

# Terraform creates VM on pve1
terraform apply
# VM 101 created on pve1
```

### Manual Migration
```bash
# Admin uses Proxmox UI to live migrate VM 101 from pve1 → pve2
# VM is now running on pve2
```

### Terraform Behavior After Migration
```bash
# Check for drift
terraform plan
# Output: No changes (node_name is ignored)

# Destroy still works
terraform destroy
# ✅ Success! Proxmox knows VM 101 is on pve2 and destroys it there
```

## Benefits
- ✅ Explicit initial placement of VMs across cluster nodes
- ✅ Flexibility to manually migrate for maintenance/balancing
- ✅ No drift warnings from Terraform
- ✅ Destroy operations still work correctly
- ✅ All other VM attributes (CPU, memory, disks) still managed by Terraform

## Risks/Considerations
- Terraform state will show VMs on their original nodes (not current location)
- `terraform show` or `terraform state` won't reflect manual migrations
- If you need to know actual VM locations, check Proxmox directly
- Terraform won't help you migrate VMs (manual operation or use Proxmox HA)

## Alternative: Terraform-Driven Migrations
Instead of ignoring migrations, you could update the config and let Terraform handle it:

```hcl
# Move VM from pve1 to pve2 by updating config
proxmox_node = "pve2"  # was "pve1"
```

**Problem:** The Proxmox provider might destroy/recreate instead of live migrate.

**Conclusion:** Use `ignore_changes` for flexibility. Update config manually to match reality when needed.

## Recommendation
Implement **Option A** - ignore node_name changes for all VMs by default. This provides maximum flexibility for cluster operations while maintaining Terraform management of VM configuration.

## Status
**PROPOSED** - Not yet implemented. Documented for future reference.
