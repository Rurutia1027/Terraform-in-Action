output "vpc_cidr_content" {
  value = var.vpc_cidr
}

output "vpc_config" {
  value = {
    name       = var.vpc_config.name
    cidr_block = var.vpc_config.cidr_block
  }
}