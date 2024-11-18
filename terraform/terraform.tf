terraform {
  required_version = "1.9.8"

  backend "local" {}

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