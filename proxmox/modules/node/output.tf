output "idle" {
  value = element(
    data.proxmox_virtual_environment_nodes.all.names,
    index(data.proxmox_virtual_environment_nodes.all.cpu_utilization,
      min(data.proxmox_virtual_environment_nodes.all.cpu_utilization...)
    )
  )
}
