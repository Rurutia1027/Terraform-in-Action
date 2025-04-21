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

locals {
  output_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
    }
  }

  output_private_subnets = {
    for key in keys(local.private_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
    }
  }
}

output "public_subnets" {
  description = "The ID and the availability zone of public subnets"
  value       = local.output_public_subnets
}

output "private_subnets" {
  description = "The ID and the availability zone of private subnets"
  value       = local.output_private_subnets
}