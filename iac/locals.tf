locals {
  resource_full_name = format("ecsdemo-%s", var.env)
  tags = {
    env = var.env
  }
}
