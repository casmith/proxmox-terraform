resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  count     = var.vm_count
  name      = var.vm_count > 1 ? "${var.vm_name}-${format("%02d", count.index + 1)}" : var.vm_name
  node_name = var.proxmox_node
  tags      = split(";", var.vm_tags)

  clone {
    vm_id = var.template_id
  }

  agent {
    enabled = true
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
    size         = tonumber(replace(var.vm_disk_size, "G", ""))
  }

  network_device {
    bridge = var.vm_network_bridge
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

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data[count.index].id
  }
}

resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
  count        = var.vm_count
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_raw {
    data = <<-EOF
    #cloud-config
    users:
      - name: ${var.vm_user}
        ssh_authorized_keys:
          - ${trimspace(var.ssh_keys)}
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: sudo
        shell: /bin/bash
    packages:
      - qemu-guest-agent
    runcmd:
      - systemctl start qemu-guest-agent
      - systemctl enable qemu-guest-agent
    EOF

    file_name = var.vm_count > 1 ? "cloud-init-${var.vm_name}-${format("%02d", count.index + 1)}.yaml" : "cloud-init-${var.vm_name}.yaml"
  }
}
