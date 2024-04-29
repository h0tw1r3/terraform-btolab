resource "proxmox_virtual_environment_download_file" "debian_12_bookworm_img" {
  content_type       = "iso"
  datastore_id       = module.ds_iso.best.id
  file_name          = "debian-12-genericcloud-amd64-20240102-1614.img"
  node_name          = module.node.idle
  url                = "https://cloud.debian.org/images/cloud/bookworm/20240102-1614/debian-12-genericcloud-amd64-20240102-1614.qcow2"
  checksum           = "49cbcfdb3d5401e8c731d33211cff5e1ef884f179a936c7378eeab00c582ace45dd7154ac9e4c059f1bd6c7ae2ce805879cb381a12a1cc493e3a58c847e134c7"
  checksum_algorithm = "sha512"
}

data "local_file" "user_ssh_pubkey" {
  filename = pathexpand(var.ssh_pub_keyfile)
}

resource "proxmox_virtual_environment_file" "vendor_cloud_config" {
  content_type = "snippets"
  datastore_id = module.ds_iso.best.id
  node_name    = module.node.idle

  source_raw {
    data = <<EOF
#cloud-config
packages:
  - qemu-guest-agent
runcmd:
  - sed -i 's|[# ]*en_US.UTF-8|en_US.UTF-8|g' /etc/locale.gen
  - locale-gen
  - systemctl start qemu-guest-agent
  - systemctl --quiet is-enabled systemd-networkd && systemctl restart systemd-networkd
EOF
    file_name = "vendor.cloud-config.yaml"
  }

  lifecycle {
    ignore_changes = [
      datastore_id,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "cluster" {
  for_each = local.instances
  name = each.value

  description = "managed by terraform"
  tags = [replace(var.hostname, "%d", ""), "terraform"]

  node_name = module.node.idle

  vm_id = sum([var.vmid_base, tonumber(substr(each.value, -1, -1))])

  cpu {
    type = "host"
    cores = var.cpu_cores
  }

  agent {
    enabled = true
  }

  migrate = true

  vga {
    enabled = true
    type    = "serial0"
  }

  memory {
    dedicated = 8192
  }

  disk {
    datastore_id = module.ds_image.best.id
    file_id   = proxmox_virtual_environment_download_file.debian_12_bookworm_img.id
    interface = "virtio0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      keys     = [trimspace(tls_private_key.provision.public_key_openssh), trimspace(data.local_file.user_ssh_pubkey.content)]
      username = var.username
    }

    vendor_data_file_id = proxmox_virtual_environment_file.vendor_cloud_config.id
  }

  network_device {
    bridge = var.bridge
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  lifecycle {
    ignore_changes = [
      node_name,
      vga["memory"],
      disk["size"],
      started,
    ]
  }
}

resource "tls_private_key" "provision" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "ssh_private_key_provision" {
  filename = "keys/id_provision"
  content  = tls_private_key.provision.private_key_openssh
}

resource "local_file" "ssh_public_key_provision" {
  filename = "keys/id_provision.pub"
  content  = tls_private_key.provision.public_key_openssh
}
