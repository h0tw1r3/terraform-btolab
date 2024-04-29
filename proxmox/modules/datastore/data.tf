data "proxmox_virtual_environment_datastores" "all" {
  node_name = var.node_name
}
