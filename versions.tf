terraform {
  required_version = ">= 1.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.70"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.1"
    }
  }

  backend "s3" {
    bucket = "terraform-state"
    key    = "proxmox/terraform.tfstate"
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

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${local.proxmox_api_token_id}=${local.proxmox_api_token_secret}"
  insecure  = var.proxmox_tls_insecure

  ssh {
    agent    = true
    username = var.proxmox_ssh_user
  }
}
