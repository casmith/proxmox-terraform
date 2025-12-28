locals {
  default_cloud_init = <<EOF
#cloud-config
users:
  - name: ${var.vm_user}
    ssh_authorized_keys:
      - ${trimspace(var.ssh_keys)}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
packages:
%{for pkg in var.cloud_init_packages~}
  - ${pkg}
%{endfor~}
runcmd:
%{if var.enable_qemu_agent && var.use_systemd_qemu_agent~}
  - systemctl start qemu-guest-agent
  - systemctl enable qemu-guest-agent
%{endif~}
%{for cmd in var.cloud_init_runcmd~}
  - ${cmd}
%{endfor~}
EOF

  cloud_init_data = var.custom_cloud_init != "" ? var.custom_cloud_init : local.default_cloud_init
}

resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
  count        = var.use_cloud_init ? var.vm_count : 0
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_raw {
    data      = local.cloud_init_data
    file_name = var.vm_count > 1 ? "cloud-init-${var.vm_name}-${format("%02d", count.index + 1)}.yaml" : "cloud-init-${var.vm_name}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  count     = var.vm_count
  name      = var.vm_count > 1 ? "${var.vm_name}-${format("%02d", count.index + 1)}" : var.vm_name
  node_name = var.proxmox_node
  tags      = split(";", var.vm_tags)
  on_boot   = true
  started   = true

  timeout_shutdown_vm = 300  # 5 minutes timeout for shutdown operations

  # Prevent replacement of existing VMs when importing from state
  lifecycle {
    ignore_changes = [
      clone,
      initialization,
    ]
  }

  clone {
    vm_id     = var.template_id
    node_name = var.template_node
    full      = true
  }

  agent {
    enabled = var.enable_qemu_agent
  }

  cpu {
    cores = var.vm_cores
    type  = "host"
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = var.vm_storage
    interface    = "scsi0"
    size         = var.vm_disk_size
  }

  network_device {
    bridge      = var.vm_network_bridge
    firewall    = false
    mac_address = length(var.vm_mac_addresses) > 0 ? var.vm_mac_addresses[count.index] : null
  }

  initialization {
    datastore_id = var.vm_storage

    user_account {
      username = var.vm_user
      keys     = length(trimspace(var.ssh_keys)) > 0 ? [trimspace(var.ssh_keys)] : []
    }

    ip_config {
      ipv4 {
        address = var.vm_ip_address == "dhcp" ? "dhcp" : var.vm_ip_address
        gateway = var.vm_ip_address == "dhcp" ? null : var.vm_gateway
      }
    }

    user_data_file_id = var.use_cloud_init ? proxmox_virtual_environment_file.cloud_init_user_data[count.index].id : null
  }
}
