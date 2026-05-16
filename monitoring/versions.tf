terraform {
  required_version = ">= 1.0"

  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.1"
    }
    uptimekuma = {
      source  = "breml/uptimekuma"
      version = "~> 0.3"
    }
  }

  backend "s3" {
    bucket = "terraform-state"
    key    = "proxmox/monitoring/terraform.tfstate"
    region = "us-east-1"

    endpoints = {
      s3 = "https://s3.kalde.in"
    }

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}
