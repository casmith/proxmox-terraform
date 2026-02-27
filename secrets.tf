# SOPS-encrypted secrets
# This file reads encrypted secrets from secrets.yaml using the SOPS provider
# Secrets are decrypted automatically during terraform operations

data "sops_file" "secrets" {
  source_file = "secrets.yaml"
}

# Local values for easy reference
locals {
  proxmox_api_token_id     = data.sops_file.secrets.data["proxmox_api_token_id"]
  proxmox_api_token_secret = data.sops_file.secrets.data["proxmox_api_token_secret"]
  ssh_keys                 = data.sops_file.secrets.data["ssh_keys"]
  s3_access_key            = data.sops_file.secrets.data["s3_access_key"]
  s3_secret_key            = data.sops_file.secrets.data["s3_secret_key"]
  uptimekuma_username      = data.sops_file.secrets.data["uptimekuma_username"]
  uptimekuma_password      = data.sops_file.secrets.data["uptimekuma_password"]
}
