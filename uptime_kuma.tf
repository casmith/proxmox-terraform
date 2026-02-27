# Uptime Kuma Monitoring
# Manages monitors for Proxmox hosts and VMs via the breml/uptimekuma provider

provider "uptimekuma" {
  endpoint = var.uptimekuma_base_url
  username = local.uptimekuma_username
  password = local.uptimekuma_password
}

# Proxmox host ping monitors
resource "uptimekuma_monitor_ping" "proxmox_hosts" {
  for_each = {
    pve1 = "192.168.10.11"
    pve2 = "192.168.10.9"
    pve3 = "192.168.10.12"
    pve4 = "192.168.10.13"
    pve5 = "192.168.10.8"
  }

  name           = "Proxmox - ${each.key}"
  hostname       = each.value
  interval       = 60
  retry_interval = 30
  max_retries    = 3
}

# VM monitors - supports ping, port, and http types
locals {
  ping_monitors = { for k, v in var.vm_monitors : k => v if v.type == "ping" }
  port_monitors = { for k, v in var.vm_monitors : k => v if v.type == "port" }
  http_monitors = { for k, v in var.vm_monitors : k => v if v.type == "http" }
}

resource "uptimekuma_monitor_ping" "vm_ping" {
  for_each = local.ping_monitors

  name           = each.value.name
  hostname       = each.value.hostname
  interval       = try(each.value.interval, 60)
  retry_interval = 30
  max_retries    = 3
}

resource "uptimekuma_monitor_tcp_port" "vm_port" {
  for_each = local.port_monitors

  name           = each.value.name
  hostname       = each.value.hostname
  port           = each.value.port
  interval       = try(each.value.interval, 60)
  retry_interval = 30
  max_retries    = 3
}

resource "uptimekuma_monitor_http" "vm_http" {
  for_each = local.http_monitors

  name                  = each.value.name
  url                   = each.value.url
  method                = "GET"
  interval              = try(each.value.interval, 60)
  retry_interval        = 30
  max_retries           = 3
  accepted_status_codes = try(each.value.accepted_status_codes, ["200-299"])
  ignore_tls            = try(each.value.ignore_tls, false)
}

# Valheim JSON query monitors
resource "uptimekuma_monitor_http_json_query" "valheim" {
  for_each = var.valheim_monitors

  name           = each.value.name
  url            = each.value.url
  json_path      = each.value.json_path
  expected_value = each.value.expected_value
  method         = "GET"
  interval       = try(each.value.interval, 60)
  retry_interval = 30
  max_retries    = 3
}
