uptimekuma_base_url = "https://uptime-obs.kalde.in"

vm_monitors = {
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
