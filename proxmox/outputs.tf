output "cluster" {
  value = {
    for k, cluster in proxmox_virtual_environment_vm.cluster : k => flatten([
      for i, ips in cluster["ipv4_addresses"] : ips if ips[0] != "127.0.0.1"
    ])
  }
}

output "datastores" {
  value = {
    image = module.ds_image.best.id
    iso = module.ds_iso.best.id
  }
}
