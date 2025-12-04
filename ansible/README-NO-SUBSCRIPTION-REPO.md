# Proxmox No-Subscription Repository Configuration

## Overview

This playbook disables the Proxmox Enterprise repository and enables the no-subscription repository to eliminate the "No valid subscription" warning on login and allow package updates without a paid subscription.

## When to Use This

- **Home labs and personal use**: Perfect for non-production Proxmox installations
- **Testing environments**: Suitable for development and testing setups
- **Learning and experimentation**: Ideal for educational purposes

## When NOT to Use This

- **Production environments**: Proxmox recommends using the enterprise repository with a valid subscription for production use
- **Mission-critical systems**: Enterprise support and thoroughly tested packages are important for critical infrastructure

## What This Playbook Does

1. **Detects your Proxmox/Debian version** automatically (Debian 11/Bullseye, 12/Bookworm, or 13/Trixie)
2. **Disables the enterprise repository** (either `/etc/apt/sources.list.d/pve-enterprise.list` or `.sources` format)
3. **Enables the no-subscription repository** with the correct suite for your version
4. **Handles both repository formats**:
   - Legacy `.list` format (Debian 11 and older)
   - Modern `.sources` format (Debian 12+)
5. **Optionally disables Ceph enterprise repository** if present
6. **Updates APT cache** so changes take effect immediately
7. **Disables the subscription popup** in the web UI login screen
8. **Backs up the original file** before modifying it (`.bak` file created)
9. **Restarts the pveproxy service** to apply web UI changes

## Usage

```bash
ansible-playbook ansible/configure-no-subscription-repo.yml
```

## What Changes Are Made

### For Proxmox VE 8.x (Debian 12 Bookworm) - Modern Format

**Disables**: `/etc/apt/sources.list.d/pve-enterprise.sources`
```
Enabled: no
```

**Creates**: `/etc/apt/sources.list.d/pve-no-subscription.sources`
```
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: bookworm
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
```

### For Proxmox VE 7.x (Debian 11 Bullseye) - Legacy Format

**Disables**: `/etc/apt/sources.list.d/pve-enterprise.list`
```
# deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise
```

**Creates**: `/etc/apt/sources.list.d/pve-no-subscription.list`
```
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
```

## After Running

1. **The subscription popup on login will be gone** - no more clicking "OK" every time
2. **Repository warnings will be eliminated** - APT updates work without errors
3. You can now update packages normally:
   ```bash
   apt update
   apt upgrade
   ```
4. **Important**: After running Proxmox updates, the web UI popup may return. Simply re-run this playbook to fix it again.

## Troubleshooting

### Still seeing the popup?

**First, check if the modification was applied:**
```bash
ansible-playbook ansible/check-subscription-popup-status.yml
```

**Common issues:**

1. **Browser cache**: The most common issue! Your browser is loading the old JavaScript file from cache.
   - **Chrome/Edge**: Press `Ctrl+Shift+R` (Windows/Linux) or `Cmd+Shift+R` (Mac)
   - **Firefox**: Press `Ctrl+F5` (Windows/Linux) or `Cmd+Shift+R` (Mac)
   - **Or**: Open the Proxmox web UI in an incognito/private window
   - **Or**: Clear your browser cache completely (Ctrl+Shift+Delete)

2. **Service not restarted**: Ensure pveproxy service was restarted
   ```bash
   systemctl restart pveproxy
   ```

3. **Verify the modification**: SSH into your Proxmox server and check:
   ```bash
   grep "orig_cmd();" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
   ```
   If this returns a match, the modification is applied.

4. **Manual fix**: If the playbook doesn't work, try manually:
   ```bash
   sed -Ezi.bak "s/(function\(orig_cmd\)\s?\{)/\1\n\torig_cmd\(\);\n\treturn;/g" \
     /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
   systemctl restart pveproxy
   ```
   Then clear your browser cache.

5. **Revert if needed**: Restore from backup:
   ```bash
   cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak \
      /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
   systemctl restart pveproxy
   ```

## Important Notes

### Repository Configuration
- Disabling the enterprise repository and enabling no-subscription is **officially supported by Proxmox** for non-production use
- The no-subscription repository receives updates **slightly later** than the enterprise repository
- Updates are **less thoroughly tested** than enterprise packages
- This is the **recommended approach** for home users and non-production environments
- You can always switch back to the enterprise repository by reversing these changes

### Web UI Popup Modification
- **The popup modification is NOT officially supported** - Proxmox staff have requested users not share these instructions on their forums
- The modification changes JavaScript logic in `/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js`
- **Updates will overwrite this change** - you'll need to re-run the playbook after Proxmox updates
- A backup is automatically created at `proxmoxlib.js.bak` before modification
- If you want to revert, restore from the backup or reinstall the `proxmox-widget-toolkit` package

## Technical Details - What Gets Modified

### Web UI Popup Fix

The playbook modifies this line in `proxmoxlib.js`:
```javascript
// Before (shows popup if NOT active):
.data.status.toLowerCase() !== 'active')

// After (shows popup only if active - never happens without subscription):
.data.status.toLowerCase() == 'active')
```

This inverts the logic so the popup only appears when you DO have an active subscription (which is never for home users).

## Sources

Based on the official Proxmox VE documentation and community best practices:
- [Proxmox VE Package Repositories](https://pve.proxmox.com/wiki/Package_Repositories)
- [Proxmox VE Helper-Scripts](https://github.com/community-scripts/ProxmoxVE)
- [Virtualization Howto - No-Subscription Configuration](https://www.virtualizationhowto.com/2022/08/proxmox-update-no-subscription-repository-configuration/)
- [DEV Community - Disable Subscription Pop-Up](https://dev.to/alexis-nieto/disable-the-no-valid-subscription-pop-up-in-proxmox-ve-841-5fao)
- [Proxmox Forum - Subscription Popup Discussion](https://forum.proxmox.com/threads/no-valid-subscription-popup-removal-pve-8-2.152981/)
