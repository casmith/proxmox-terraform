resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = var.vm_name
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
  }
}
