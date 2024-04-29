locals {
  want_ct_i = [
    for i, v in data.proxmox_virtual_environment_datastores.all.content_types : i if contains(v, var.content_type)
  ]

  ct_max_space = max([ for i in local.want_ct_i :
    data.proxmox_virtual_environment_datastores.all.space_available[i]
  ]...)

  ds_i = index(
    data.proxmox_virtual_environment_datastores.all.space_available,
    local.ct_max_space
  )

  best = {
    for k, v in data.proxmox_virtual_environment_datastores.all :
      k == "datastore_ids" ? "id" : k => v[local.ds_i] if can(v[local.ds_i])
  }

  all = {
    for i in local.want_ct_i :
      data.proxmox_virtual_environment_datastores.all.datastore_ids[i] => {
        for k, v in data.proxmox_virtual_environment_datastores.all :
          k => v[i] if k != "datastore_ids" && can(v[i])
      }
  }
}
