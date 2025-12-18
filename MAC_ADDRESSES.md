# MAC Address Assignments

This file tracks which MAC addresses are assigned to which VMs.

## Assigned MAC Addresses

| MAC Address        | VM Name                    | Node | Notes                           | IP Address      |
|--------------------|----------------------------|------|---------------------------------| --------------- |
| 52:54:00:c4:9c:d7  | pve1-talos-vm-01           | pve1 | Talos Kubernetes node           | 192.168.10.33   |
| 52:54:00:4d:e5:5d  | pve1-talos-vm-02           | pve1 | Talos Kubernetes node           | 192.168.10.34   |
| 52:54:00:06:d2:7f  | pve1-ubuntu-vm-01          | pve1 | Ubuntu 24.04 LTS                | 192.168.10.35   |
| 52:54:00:33:3f:a8  | pve1-ubuntu-vm-02          | pve1 | Ubuntu 24.04 LTS                | 192.168.10.36   |
| 52:54:00:5a:52:e9  | pve1-talos-sandbox-pve1-01 | pve1 | Talos sandbox/experimental      | 192.168.10.37   |
| 52:54:00:cd:0f:61  | pve2-talos-vm-01           | pve2 | Talos Kubernetes node           | 192.168.10.44   |
| 52:54:00:0c:08:a7  | pve2-talos-sandbox-pve2-01 | pve2 | Talos sandbox/experimental      | 192.168.10.38   |
| 52:54:00:9c:30:b8  | pve2-talos-sandbox-pve2-02 | pve2 | Talos sandbox/experimental      | 192.168.10.39   |
| 52:54:00:36:34:cb  | pve2-ubuntu-vm-01          | pve2 | Ubuntu 24.04 LTS (2GB RAM)      | 192.168.10.40   |
| 52:54:00:0d:69:41  | pve2-ubuntu-highmem-vm-01  | pve2 | Ubuntu 24.04 LTS (8GB RAM)      | 192.168.10.41   |
| 52:54:00:e5:d5:f4  | pve3-ubuntu-vm-01          | pve3 | Ubuntu 24.04 LTS (2GB RAM)      | 192.168.10.42   |
| 52:54:00:e9:c8:5a  | pve3-ubuntu-highmem-vm-01  | pve3 | Ubuntu 24.04 LTS (8GB RAM)      | 192.168.10.43   |

## Available MAC Addresses

The following MAC addresses are available for future VMs:

```
52:54:00:ff:c1:cc - 192.168.10.45
52:54:00:29:bf:af - 192.168.10.46
52:54:00:62:80:ec - 192.168.10.47
52:54:00:f8:69:f9 - 192.168.10.48
52:54:00:ed:b7:ca - 192.168.10.49
52:54:00:dd:14:d9 - 192.168.10.50
52:54:00:15:09:5d - 192.168.10.51
52:54:00:11:67:63 - 192.168.10.52
52:54:00:1b:8a:3f - 192.168.10.53
52:54:00:cd:1f:ce - 192.168.10.54
52:54:00:c1:a0:57 - 192.168.10.55
52:54:00:c3:6c:4f - 192.168.10.56
52:54:00:73:37:b4 - 192.168.10.57
52:54:00:6b:75:7a - 192.168.10.58
52:54:00:2e:bd:67 - 192.168.10.59
52:54:00:e7:87:b7 - 192.168.10.60
52:54:00:a8:bc:91 - 192.168.10.61
52:54:00:12:88:f7 - 192.168.10.62
52:54:00:86:31:b0 - 192.168.10.63
52:54:00:5c:38:dd - 192.168.10.64
52:54:00:c8:94:2b - 192.168.10.65
52:54:00:92:de:10 - 192.168.10.66
52:54:00:a3:7b:68 - 192.168.10.67
52:54:00:5a:de:f1 - 192.168.10.68
52:54:00:b1:13:77 - 192.168.10.69
52:54:00:04:c6:23 - 192.168.10.70
```

## Notes

- All MAC addresses use the QEMU/KVM reserved prefix `52:54:00:xx:xx:xx`
- These are locally administered addresses that won't conflict with real hardware
- When adding new VMs, take the next available MAC from the list above
- Update this file when assigning or removing MAC addresses
- Keep DHCP reservations in sync with these assignments
