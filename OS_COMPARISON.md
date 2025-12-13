# Operating System Templates - Comparison Guide

## Quick Reference

| OS | Template ID | Setup Time | Automation | Use Case |
|----|-------------|------------|------------|----------|
| **Ubuntu 24.04** | 9000 | 5 min | Full | General purpose, web apps, containers |
| **Talos Linux** | 9001 | 5 min | Full | Kubernetes nodes, immutable infrastructure |
| **Windows 11** | 9002 | 30 min | Partial | .NET apps, Windows services, desktop apps |
| **FreeBSD 15.0** | 9003 | 5 min | Full | Network appliances, ZFS, jails, stability |

## Detailed Comparison

### Setup & Automation

| Feature | Ubuntu | Talos | Windows | FreeBSD |
|---------|--------|-------|---------|---------|
| **Playbook** | setup-ubuntu2404-template.yml | setup-talos-template.yml | setup-windows-template.yml | setup-freebsd-template.yml |
| **Fully Automated** | ✅ Yes | ✅ Yes | ❌ No | ✅ Yes |
| **Manual Steps** | None | None | Many | None |
| **Download Source** | Ubuntu Cloud | Talos Factory | Microsoft | FreeBSD Official |
| **Setup Time** | ~5 min | ~5 min | ~30 min | ~5 min |

### Cloud-Init Support

| Feature | Ubuntu | Talos | Windows | FreeBSD |
|---------|--------|-------|---------|---------|
| **Cloud-Init** | ✅ Native | ⚠️ Limited | ✅ cloudbase-init | ✅ Native |
| **User Creation** | ✅ Yes | ❌ No | ✅ Yes | ✅ Yes |
| **SSH Keys** | ✅ Yes | ⚠️ Different | ✅ Yes | ✅ Yes |
| **Package Install** | ✅ Yes | ❌ No | ⚠️ Limited | ✅ Yes |
| **Custom Commands** | ✅ Yes | ⚠️ Limited | ✅ Yes | ✅ Yes |

### Hardware & Drivers

| Feature | Ubuntu | Talos | Windows | FreeBSD |
|---------|--------|-------|---------|---------|
| **VirtIO Disk** | ✅ Built-in | ✅ Built-in | 📦 External | ✅ Built-in |
| **VirtIO Network** | ✅ Built-in | ✅ Built-in | 📦 External | ✅ Built-in |
| **QEMU Agent** | 📦 Auto-install | 📦 In image | 📦 Manual | 📦 Auto-install |
| **UEFI Support** | ✅ Yes | ✅ Yes | ✅ Required | ✅ Yes |
| **TPM Support** | ⚠️ Optional | ⚠️ Optional | ✅ Required | ⚠️ Optional |

### Resource Requirements

| Metric | Ubuntu | Talos | Windows | FreeBSD |
|--------|--------|-------|---------|---------|
| **Min CPU** | 1 core | 2 cores | 2 cores | 1 core |
| **Min RAM** | 512 MB | 2 GB | 4 GB | 512 MB |
| **Recommended RAM** | 2 GB | 4 GB | 8 GB | 2 GB |
| **Min Disk** | 10 GB | 20 GB | 40 GB | 10 GB |
| **Recommended Disk** | 20 GB | 30 GB | 60 GB | 20 GB |
| **Default Config** | 2 core, 2GB | 2 core, 4GB | 4 core, 8GB | 2 core, 2GB |

### Operating System Features

| Feature | Ubuntu | Talos | Windows | FreeBSD |
|---------|--------|-------|---------|---------|
| **License** | Free (GPL) | Free (MPL) | Commercial | Free (BSD) |
| **Package Manager** | apt | None | winget/chocolatey | pkg |
| **Init System** | systemd | Custom | Services | rc.d |
| **Container Runtime** | Docker/containerd | containerd | Docker Desktop | Docker/jails |
| **Orchestration** | Any | Kubernetes only | Kubernetes | Any |
| **Filesystem** | ext4 | XFS/ext4 | NTFS | UFS/ZFS |

### Best Use Cases

#### Ubuntu 24.04 LTS
**Best For:**
- General-purpose servers
- Web applications (LAMP/LEMP)
- Containerized applications
- CI/CD pipelines
- Development environments
- Microservices

**Strengths:**
- Huge package repository
- Excellent hardware support
- Large community
- LTS support (5 years)
- Well-documented

#### Talos Linux
**Best For:**
- Kubernetes clusters
- Immutable infrastructure
- Edge computing
- Security-focused deployments
- GitOps workflows

**Strengths:**
- Minimal attack surface
- Immutable OS
- API-driven management
- Built for Kubernetes
- Automatic updates
- No SSH (secure by design)

#### Windows 11
**Best For:**
- .NET applications
- Windows-specific services
- Active Directory
- Microsoft SQL Server
- Desktop applications
- Legacy Windows apps

**Strengths:**
- Native .NET support
- Windows ecosystem
- GUI applications
- Enterprise integration
- PowerShell automation

**Weaknesses:**
- Higher resource usage
- Licensing costs
- Manual template setup
- Larger attack surface

#### FreeBSD 15.0
**Best For:**
- Network appliances
- Routers/firewalls
- Storage servers (ZFS)
- Jails (OS virtualization)
- High-performance servers
- Unix development

**Strengths:**
- Rock-solid stability
- ZFS filesystem
- Jails isolation
- Advanced networking (pf)
- Excellent performance
- Permissive license
- Complete system (not just kernel)

## Network Configuration

| OS | Interface Name | DHCP | Static IP | IPv6 |
|----|----------------|------|-----------|------|
| Ubuntu | eth0/ens18 | ✅ Yes | ✅ Yes | ✅ Yes |
| Talos | eth0 | ✅ Yes | ✅ Yes | ✅ Yes |
| Windows | Ethernet | ✅ Yes | ✅ Yes | ✅ Yes |
| FreeBSD | vtnet0 | ✅ Yes | ✅ Yes | ✅ Yes |

## Security & Updates

| Feature | Ubuntu | Talos | Windows | FreeBSD |
|---------|--------|-------|---------|---------|
| **Security Updates** | apt upgrade | Auto-update | Windows Update | freebsd-update |
| **Patch Frequency** | Daily | Continuous | Monthly | Quarterly |
| **Firewall** | ufw/iptables | Host firewall | Windows Firewall | pf |
| **SELinux/AppArmor** | AppArmor | None | None | None |
| **Vulnerability Scan** | Many tools | Built-in | Defender | pkg audit |

## Terraform Integration

| Feature | Ubuntu | Talos | Windows | FreeBSD |
|---------|--------|-------|---------|---------|
| **Module Path** | ./ubuntu | ./talos | ./windows | ./freebsd |
| **Variables Prefix** | ubuntu_* | talos_* | windows_* | freebsd_* |
| **IP Detection** | QEMU agent | QEMU agent | QEMU agent | QEMU agent |
| **Ready Time** | 30-60s | 60-90s | 2-3 min | 30-60s |
| **Disk Expansion** | Auto | Auto | Auto | Auto |

## Performance Characteristics

### Boot Time
1. **Talos**: ~20 seconds (minimal OS)
2. **FreeBSD**: ~30 seconds
3. **Ubuntu**: ~30 seconds
4. **Windows**: ~60+ seconds

### Memory Usage (Idle)
1. **Talos**: ~400 MB
2. **FreeBSD**: ~200 MB
3. **Ubuntu**: ~300 MB
4. **Windows**: ~2+ GB

### Disk I/O
1. **FreeBSD**: Excellent (especially with ZFS)
2. **Ubuntu**: Very Good
3. **Talos**: Very Good
4. **Windows**: Good

### Network Performance
1. **FreeBSD**: Excellent
2. **Talos**: Excellent
3. **Ubuntu**: Very Good
4. **Windows**: Good

## Package Management

### Installing Software

**Ubuntu:**
```bash
apt update && apt install nginx postgresql
```

**Talos:**
```yaml
# Packages built into image, no runtime installation
# Use system extensions or container images
```

**Windows:**
```powershell
# Via cloudbase-init during provisioning
# Or: choco install nginx postgresql
```

**FreeBSD:**
```bash
pkg update && pkg install nginx postgresql15-server
```

## When to Choose Each OS

### Choose Ubuntu if:
- You need a general-purpose server
- You want the largest package ecosystem
- You need wide hardware support
- You prefer Debian-based systems
- You want long-term support (LTS)

### Choose Talos if:
- You're running Kubernetes
- You want immutable infrastructure
- Security is paramount
- You embrace GitOps
- You don't need general-purpose OS features

### Choose Windows if:
- You need .NET Framework/.NET apps
- You require Active Directory
- You have Windows-specific applications
- You need Microsoft ecosystem integration
- You have Windows licensing

### Choose FreeBSD if:
- You need ZFS filesystem
- You want jails for isolation
- You're building network appliances
- You need maximum stability
- You prefer BSD licensing
- You want advanced networking features

## Cost Considerations

| OS | License Cost | Support Cost | Resource Cost |
|----|--------------|--------------|---------------|
| Ubuntu | Free | Optional | Low |
| Talos | Free | Optional | Medium |
| Windows | $$ Per VM | Included | High |
| FreeBSD | Free | Optional | Low |

**Notes:**
- Windows requires licensing per VM (retail, volume, or evaluation)
- All others are free to use in production
- Support is available commercially for all
- Resource cost = infrastructure costs based on requirements

## Real-World Examples

### Web Application Stack
- **Frontend**: Ubuntu (nginx, Node.js)
- **Backend**: Ubuntu (Python/Go microservices)
- **Database**: FreeBSD (PostgreSQL on ZFS)
- **Orchestration**: Talos (Kubernetes cluster)

### Enterprise Application
- **Application Server**: Windows (IIS, .NET apps)
- **Database**: Windows (SQL Server)
- **Load Balancer**: FreeBSD (nginx, pf firewall)
- **Monitoring**: Ubuntu (Prometheus, Grafana)

### Edge Computing
- **Edge Nodes**: Talos (Kubernetes edge)
- **Gateway**: FreeBSD (routing, firewall)
- **Management**: Ubuntu (control plane)

## Migration Paths

### From Other Systems

**VMware → Proxmox:**
- All templates support VM imports
- Convert VMDK to qcow2 or raw
- Use same cloud-init configs

**AWS/Azure → On-Premises:**
- Ubuntu/FreeBSD: Use same cloud images
- Talos: Platform-agnostic
- Windows: Re-provision with template

**Physical → Virtual:**
- Use these templates for new deployments
- Migrate data, not OS installations

## Summary Table

| Metric | Ubuntu | Talos | Windows | FreeBSD |
|--------|--------|-------|---------|---------|
| **Ease of Setup** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **General Purpose** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Containers** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Performance** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Security** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Community** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Documentation** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Resource Usage** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Learning Curve** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

**Rating Scale:** ⭐ = Poor, ⭐⭐⭐ = Average, ⭐⭐⭐⭐⭐ = Excellent

## Conclusion

All four templates are production-ready and integrate seamlessly with Terraform. Choose based on your specific needs:

- **Most Versatile**: Ubuntu
- **Best for K8s**: Talos
- **Windows Apps**: Windows 11
- **Stability/ZFS**: FreeBSD

The modular architecture makes it easy to run multiple OS types in the same infrastructure!
