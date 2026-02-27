# Uptime Kuma Monitoring
# Manages ping monitors for Proxmox hosts via the ehealth-co-id/uptimekuma provider

provider "uptimekuma" {
  base_url = var.uptimekuma_base_url
  username = local.uptimekuma_username
  password = local.uptimekuma_password
}

# Proxmox host ping monitors
resource "uptimekuma_monitor" "proxmox_hosts" {
  for_each = {
    pve1 = "192.168.10.11"
    pve2 = "192.168.10.9"
    pve3 = "192.168.10.12"
    pve4 = "192.168.10.13"
    pve5 = "192.168.10.8"
  }

  name           = "Proxmox - ${each.key}"
  type           = "ping"
  hostname       = each.value
  interval       = 60
  retry_interval = 30
  max_retries    = 3
}
