module "node" {
  source = "./modules/node"
}

module "ds_image" {
  source = "./modules/datastore"

  node_name = module.node.idle
  content_type = "images"
}

module "ds_iso" {
  source = "./modules/datastore"

  node_name = module.node.idle
  content_type = "iso"
}

module "ssh" {
  for_each = local.instances
  name = each.value
  source = "./modules/ssh"
}
