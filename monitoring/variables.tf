variable "uptimekuma_base_url" {
  description = "Uptime Kuma base URL"
  type        = string
  default     = "https://uptime-obs.kalde.in"
}

variable "vm_monitors" {
  description = "Map of VM monitors for Uptime Kuma. Key is a unique identifier. Each entry needs: name, type (ping|port|http), hostname (for ping/port), port (for port), url (for http)."
  type        = map(any)
  default     = {}
}

variable "valheim_monitors" {
  description = "Map of Valheim server monitors using HTTP JSON query. Each entry needs: name, url, json_path, expected_value."
  type = map(object({
    name           = string
    url            = string
    json_path      = string
    expected_value = string
    interval       = optional(number)
  }))
  default = {}
}
