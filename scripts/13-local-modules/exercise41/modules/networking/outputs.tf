output "vpc_config" {
  value = {
    name       = var.vpc_config.name
    cidr_block = var.vpc_config.cidr_block
  }
}

output "subnet_config_output" {
  value       = var.subnet_config
  description = "The configuration of the subnets, including CIDR blocks and AZs"
}