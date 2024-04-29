terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
    }
    tls = {
      source  = "hashicorp/tls"
    }
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}
