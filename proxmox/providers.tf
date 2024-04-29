provider "proxmox" {
  endpoint = var.pve_endpoint
  username = var.pve_username
  api_token = var.pve_api_token
  insecure = var.pve_endpoint_insecure
  ssh {
    agent = true
    username = "root"
  }
}
