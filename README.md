# BTO Lab Terraform

Playground for testing terraform in a lab environment.

Each directory should contain an example of provisioning infrastructure on
various providers.

## [Proxmox](proxmox/)

Example using the [bpg/proxmox] provider to create an [Incus] cluster.

Demonstrates how use modules to abstract and manipulate data from
providers to dynamically assign values to resources.

[bpg/proxmox]: https://registry.terraform.io/providers/bpg/proxmox/latest
[Incus]: https://linuxcontainers.org/incus/
