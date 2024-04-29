variable "pve_endpoint" {
  type        = string
  description = "The endpoint for the Proxmox Virtual Environment API (example: https://host:port)"
  default     = "https://192.168.50.50:8006"
}

variable "pve_endpoint_insecure" {
  type        = bool
  description = "Is the endpoint certificate self signed?"
  default     = true
}

variable "pve_username" {
  type        = string
  description = "The username and realm for the Proxmox Virtual Environment API (example: root@pam)"
  default     = "root@pam"
}

variable "pve_api_token" {
  type        = string
  description = "Privileged api token for a accessing the PVE API"
  sensitive   = true
}

variable "username" {
  type        = string
  description = "The cloud-init user name"
  default     = "provision"
}

variable "ssh_pub_keyfile" {
  type        = string
  description = "The cloud-init user public key file to authorize in addition to generated keys (optional)"
  default     = "~/.ssh/id_ed25519.pub"
}

variable "vmid_base" {
  type        = number
  description = "Base vm id"
  default     = 2100
}

variable "hostname" {
  type        = string
  description = "Hostname format, %d may be embedded for the instance number, or the instance number will be appended"
  default     = "incus"
}

variable "cluster" {
  type        = number
  description = "Number of VMs in cluster"
  default     = 3
}

variable "cpu_cores" {
  type        = number
  description = "Number of cpu cores per VM"
  default     = 2
}

variable "bridge" {
  type        = string
  description = "The Proxmox bridge to use"
  default     = "vmbr1"
}
