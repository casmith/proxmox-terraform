# Root Terraform Configuration
# Node-based architecture - configure VMs per node

# ============================================================================
# Shared Configuration (applies to all nodes)
# ============================================================================

vm_storage        = "local-lvm"
vm_network_bridge = "vmbr0"
vm_ip_address     = "dhcp"
vm_gateway        = "192.168.10.1"

# ============================================================================
# pve1 Node Configuration
# ============================================================================

# Template IDs on pve1 (local-lvm storage)
pve1_ubuntu_template_id    = 9000
pve1_talos_template_id     = 9001
pve1_archlinux_template_id = 9002

# Ubuntu VMs on pve1
pve1_ubuntu_vm_count         = 2
pve1_ubuntu_vm_name          = "ubuntu-vm"
pve1_ubuntu_vm_cores         = 2
pve1_ubuntu_vm_memory        = 2048
pve1_ubuntu_vm_disk_size     = 20
pve1_ubuntu_vm_mac_addresses = ["52:54:00:06:d2:7f", "52:54:00:33:3f:a8"]

# Arch Linux VMs on pve1
pve1_archlinux_vm_count     = 1
pve1_archlinux_vm_name      = "arch-vm"
pve1_archlinux_vm_cores     = 2
pve1_archlinux_vm_memory    = 2048
pve1_archlinux_vm_disk_size = 20

# Talos VMs on pve1
pve1_talos_vm_count         = 1
pve1_talos_vm_name          = "talos-vm"
pve1_talos_vm_cores         = 8
pve1_talos_vm_memory        = 12288
pve1_talos_vm_disk_size     = 100
pve1_talos_vm_mac_addresses = ["52:54:00:c4:9c:d7"]

# Talos Sandbox VMs on pve1
pve1_talos_sandbox_vm_count         = 1
pve1_talos_sandbox_vm_name          = "talos-sandbox-pve1"
pve1_talos_sandbox_vm_cores         = 4
pve1_talos_sandbox_vm_memory        = 4096
pve1_talos_sandbox_vm_disk_size     = 30
pve1_talos_sandbox_vm_mac_addresses = ["52:54:00:5a:52:e9"]

# Talos Obs VMs on pve1
pve1_talos_obs_vm_count         = 1
pve1_talos_obs_vm_name          = "talos-obs"
pve1_talos_obs_vm_cores         = 4
pve1_talos_obs_vm_memory        = 8192
pve1_talos_obs_vm_disk_size     = 50
pve1_talos_obs_vm_mac_addresses = ["52:54:00:62:80:ec"]

# ============================================================================
# pve2 Node Configuration
# ============================================================================

# Template IDs on pve2 (local-lvm storage)
pve2_ubuntu_template_id = 9100
pve2_talos_template_id  = 9101

# Ubuntu VMs on pve2
pve2_ubuntu_vm_count         = 1
pve2_ubuntu_vm_name          = "ubuntu-vm"
pve2_ubuntu_vm_cores         = 2
pve2_ubuntu_vm_memory        = 2048
pve2_ubuntu_vm_disk_size     = 20
pve2_ubuntu_vm_mac_addresses = ["52:54:00:36:34:cb"]

# Ubuntu High-Memory VMs on pve2
pve2_ubuntu_highmem_vm_count         = 1
pve2_ubuntu_highmem_vm_name          = "ubuntu-highmem-vm"
pve2_ubuntu_highmem_vm_cores         = 4
pve2_ubuntu_highmem_vm_memory        = 8192
pve2_ubuntu_highmem_vm_disk_size     = 20
pve2_ubuntu_highmem_vm_mac_addresses = ["52:54:00:0d:69:41"]

# Talos VMs on pve2
pve2_talos_vm_count         = 1
pve2_talos_vm_name          = "talos-vm"
pve2_talos_vm_cores         = 8
pve2_talos_vm_memory        = 12288
pve2_talos_vm_disk_size     = 100
pve2_talos_vm_mac_addresses = ["52:54:00:cd:0f:61"]

# Talos Sandbox VMs on pve2
pve2_talos_sandbox_vm_count         = 2
pve2_talos_sandbox_vm_name          = "talos-sandbox-pve2"
pve2_talos_sandbox_vm_cores         = 4
pve2_talos_sandbox_vm_memory        = 4096
pve2_talos_sandbox_vm_disk_size     = 30
pve2_talos_sandbox_vm_mac_addresses = ["52:54:00:0c:08:a7", "52:54:00:9c:30:b8"]

# Talos Obs VMs on pve2
pve2_talos_obs_vm_count         = 1
pve2_talos_obs_vm_name          = "talos-obs"
pve2_talos_obs_vm_cores         = 4
pve2_talos_obs_vm_memory        = 8192
pve2_talos_obs_vm_disk_size     = 50
pve2_talos_obs_vm_mac_addresses = ["52:54:00:f8:69:f9"]

# ============================================================================
# pve3 Node Configuration
# ============================================================================

# Template IDs on pve3 (local-lvm storage)
pve3_ubuntu_template_id = 9200
pve3_talos_template_id  = 9201

# Ubuntu VMs on pve3
pve3_ubuntu_vm_count         = 1
pve3_ubuntu_vm_name          = "ubuntu-vm"
pve3_ubuntu_vm_cores         = 2
pve3_ubuntu_vm_memory        = 2048
pve3_ubuntu_vm_disk_size     = 20
pve3_ubuntu_vm_mac_addresses = ["52:54:00:e9:c8:5a"]

# Ubuntu High-Memory VMs on pve3
pve3_ubuntu_highmem_vm_count         = 1
pve3_ubuntu_highmem_vm_name          = "ubuntu-highmem-vm"
pve3_ubuntu_highmem_vm_cores         = 2
pve3_ubuntu_highmem_vm_memory        = 8192
pve3_ubuntu_highmem_vm_disk_size     = 20
pve3_ubuntu_highmem_vm_mac_addresses = ["52:54:00:e5:d5:f4"]

# Talos VMs on pve3 (disabled)
pve3_talos_vm_count = 0

# Talos Sandbox VMs on pve3 (disabled)
pve3_talos_sandbox_vm_count = 0

# Talos Obs VMs on pve3
pve3_talos_obs_vm_count         = 1
pve3_talos_obs_vm_name          = "talos-obs"
pve3_talos_obs_vm_cores         = 4
pve3_talos_obs_vm_memory        = 8192
pve3_talos_obs_vm_disk_size     = 50
pve3_talos_obs_vm_mac_addresses = ["52:54:00:ed:b7:ca"]

# ============================================================================
# pve4 Node Configuration
# ============================================================================

# Template IDs on pve4 (local-lvm storage)
pve4_ubuntu_template_id = 9300
pve4_talos_template_id  = 9301

# Ubuntu VMs on pve4
pve4_ubuntu_vm_count         = 1
pve4_ubuntu_vm_name          = "ubuntu-vm"
pve4_ubuntu_vm_cores         = 2
pve4_ubuntu_vm_memory        = 2048
pve4_ubuntu_vm_disk_size     = 20
pve4_ubuntu_vm_mac_addresses = ["52:54:00:ff:c1:cc"]

# Ubuntu High-Memory VMs on pve4
pve4_ubuntu_highmem_vm_count         = 1
pve4_ubuntu_highmem_vm_name          = "ubuntu-highmem-vm"
pve4_ubuntu_highmem_vm_cores         = 2
pve4_ubuntu_highmem_vm_memory        = 8192
pve4_ubuntu_highmem_vm_disk_size     = 20
pve4_ubuntu_highmem_vm_mac_addresses = ["52:54:00:29:bf:af"]

# Talos VMs on pve4 (disabled)
pve4_talos_vm_count = 0

# Talos Sandbox VMs on pve4 (disabled)
pve4_talos_sandbox_vm_count = 0

# ============================================================================
# pve5 Node Configuration
# ============================================================================

# Template IDs on pve5 (local-lvm storage)
pve5_ubuntu_template_id = 9400
pve5_talos_template_id  = 9401

# Ubuntu VMs on pve5 (disabled)
pve5_ubuntu_vm_count = 0

# Ubuntu High-Memory VMs on pve5
pve5_ubuntu_highmem_vm_count         = 1
pve5_ubuntu_highmem_vm_name          = "ubuntu-highmem-vm"
pve5_ubuntu_highmem_vm_cores         = 4
pve5_ubuntu_highmem_vm_memory        = 8192
pve5_ubuntu_highmem_vm_disk_size     = 50
pve5_ubuntu_highmem_vm_mac_addresses = ["52:54:00:dd:14:d9"]

# Talos VMs on pve5 (disabled)
pve5_talos_vm_count = 0

# Talos Sandbox VMs on pve5 (disabled)
pve5_talos_sandbox_vm_count = 0

# Talos Obs VMs on pve5 (disabled)
pve5_talos_obs_vm_count = 0

# ============================================================================
# Uptime Kuma VM Monitors
# ============================================================================
# Each entry needs: name, type (ping|port|http)
#   ping: requires hostname
#   port: requires hostname + port
#   http: requires url (optional: accepted_status_codes, ignore_tls)
# All types support optional: interval (default 60)

vm_monitors = {
  # Example ping monitor - basic VM reachability
  # "ubuntu-vm-01" = {
  #   name     = "VM - ubuntu-vm-01"
  #   type     = "ping"
  #   hostname = "192.168.10.x"
  # }

  # Example port monitor - check a specific service port
  # "talos-vm-01-k8s-api" = {
  #   name     = "Talos - talos-vm-01 K8s API"
  #   type     = "port"
  #   hostname = "192.168.10.x"
  #   port     = 6443
  # }

  # Example HTTP monitor - check a web service
  # "my-web-app" = {
  #   name       = "App - my-web-app"
  #   type       = "http"
  #   url        = "https://myapp.kalde.in"
  #   ignore_tls = true
  # }

  "pve1-ubuntu-1" = {
    name     = "VM - pve1-ubuntu-1"
    type     = "ping"
    hostname = "192.168.10.35"
  }

  "pve5-ubuntu-highmem-1" = {
    name     = "VM - pve5-ubuntu-highmem-1"
    type     = "ping"
    hostname = "192.168.10.50"
  }

  "immich" = {
    name = "App - immich"
    type = "http"
    url  = "https://photos.kalde.in"
  }
}

valheim_monitors = {
  "valheim-1" = {
    name           = "Valheim - Server 1"
    url            = "http://192.168.10.41:9001/status.json"
    json_path      = <<-EOT
      (
         $now := $toMillis($now()[0]);
         $lastUpdate := $toMillis(last_status_update);
         $minutesDiff := ($now - $lastUpdate) / 60000;
         error = null and $minutesDiff <= 1 ? "healthy" : "unhealthy"
      )
    EOT
    expected_value = "healthy"
  }
}

