locals {
  instances = toset([
    for i in range(var.cluster) :
      strcontains(var.hostname, "%d") ? format(var.hostname, i) : format("%s%d", var.hostname, i)
  ])
}
