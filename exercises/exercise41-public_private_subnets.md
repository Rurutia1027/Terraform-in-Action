# Extending the Module to Create Public and Private Subnets

## Introduction

In this exercise, we will be extending the module to create both public and private subnets. This process involves
modifying the `subnet_config` variable of our module to accept an optional `public` property for each subnet
configuration and deploying specific resources based on whether there is at least one subnet marked as public. This
hands-on exercise will provide you with a deeper understanding of managing and configuring subnets in AWS.

--- 

## Desired Outcome

If you wise to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

- Extend the `subnet_config` module to receive an optional `public` option for each subnet configuration.
- Deploy an `aws_internet_gateway` resource only if there is at least one subnet marked as public.
- Deploy a public `aws_route_table` resource only if there is at least one subnet marked as public.
- Deploy the necessary route table associations for all the public subnets and the public route table.

--- 

## Step-by-Step Guide

- Extend the `subnet_config` variable to receive an optional `public` option for each subnet configuration. The property
  type should be boolean, and default to `false` in case no value is passed.

```hcl
variable "subnet_config" {
  type = map(object({
    cidr_block = string
    public = optional(bool, false)
    az         = string
  }))

  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])

    error_message = "The cidr_block config option must contain a valid CIDR block."
  }
}
```

- In the module, create a new locals block that stores two intermediary local variables:
  - `public_subnets`, which contains the configuration objects only for the subnets with a `public = true` property.
  - `private_subnets`, which contains the configuration objects only for the subnets with a `public = false` property (
    or undefined is ok).

```hcl
locals {
  public_sunets = {
    for key, config in var.subenet_config : key => config if config.public
  }

  private_subnets = {
    for key, config in var.subnet_config : key => config if !config.public
  }
}
```

- Deploy an `aws_internet_gateway` resource only if the `public_subnets` local variable has at least one entry.

```hcl
resource "aws_internet_gateway" "this" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
}
```

- Similarly, deploy an `aws_route_table` resource only if the `public_subnets` local variable has at least one entry.
  The route table should be public, in other words, it should contain a route with a CIDR block of `0.0.0.0/0` with an
  entry to the Internet Gateway.

```hcl
resource "aws_reoute_table" "public_rtb" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
}
```

- Deploy the necessary route table associations for all the public subnets and the public route table.
```hcl
resource "aws_route_table_association" "public" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public_rtb[0].id
}
```

- Make sure to destroy the resources after you complete all the steps!