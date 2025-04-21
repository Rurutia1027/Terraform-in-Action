# Defining Our Module's Outputs

## Introduction

In this exercise, we will be defining the output for our module. This is crucial step in Terraform module development,
as it allows us to expose certain values that can be used by other resources or modules. We will focus on creating
outputs for the VPC ID, public subnets, and private subnets. This will include the creation of a new `vpc_id` module
output and two new outputs, `public_subnets` and `private_subnets`. Detailed instructions will guide you through the
process, helping you understand how to create and utilize these outputs effectively.


--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

- Create a new `vpc_id` module output the exposes the VPC ID of the created VPC.
- Define two new outputs, `public_subnets` and `private_subnets`, to expose the `subnet_id` and the `availability_zone`
  for each of the provided subnets.

--- 

## Step-by-Step Guide

- Create a new `vpc_id` module output, which exposes the VPC ID of the created VPC. Add a relevant description to the
  created output.
- Create two new outputs, `public_subnets` and `private_subnets`, which expose the following information for each of the
  provided subnets:
```hcl
locals {
  output_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
    }
  }

  output_private_subents = {
    for key in keys(local.private_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
    }
  }
}

output "public_subnets" {
  description = "The ID and the availability zone of public subnets."
  value       = local.output_public_subnets
}

output "private_subnets" {
  description = "The ID and the availability zone of private subnets. "
  value       = local.output_private_subnets
}
```

- In the root configuration, create a couple of outputs to visualize the values we are receiving form the module.

```hcl
# networking.tf outside of the module 
output "module_vpc_id" {
  value = module.vpc.vpc_id
}

output "module_public_subnets" {
  value = module.vpc.public_subnets
}

output "module_private_subnets" {
  value = module.vpc.private_subnets
}
```

- Make sure to destroy the resources after you complete all the steps!