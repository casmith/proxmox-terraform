data "sops_file" "secrets" {
  source_file = "../secrets.yaml"
}

locals {
  uptimekuma_username = data.sops_file.secrets.data["uptimekuma_username"]
  uptimekuma_password = data.sops_file.secrets.data["uptimekuma_password"]
}
