module "vpc" {
  source = "./modules/networking"
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "13-local-modules-exe40"
  }
  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.0.0/24"
      az         = "eu-west-1a"
    }
  }
}


output "output_vpc_cidr_block" {
  value = module.vpc.vpc_config.cidr_block
}

output "output_vpc_name" {
  value = module.vpc.vpc_config.name
}

output "subnet_config" {
  value       = module.vpc.subnet_config_output
  description = "The configuration of the subnets, passed from the module."
}