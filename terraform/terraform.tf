terraform {
  required_version = "1.9.8"

  backend "s3" {
    key                         = "cloudflare-ddns.tfstate"
    region                      = "main"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
    awx = {
      source  = "denouche/awx"
      version = "0.19.0"
    }
  }
}