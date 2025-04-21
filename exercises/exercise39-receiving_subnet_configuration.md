# Extending the VPC Module to Receive Subnet Configuration

## Introduction

In this exercise, we are going to extend the VPC Module to receive the subnet configuration and create the respective
resources. We will add a new module variable, adjust the module block in the root configuration, and create a new
resource within the module. We'll use the `for_each` loop and the `subnet_config` variable. This detailed guide will
walk you through all the steps required to achieve this.

--- 

## Desired Outcome

If you wish to give a shot before looking into the detailed step-by-step and the solution videos, here is an overview of
what the created solution should deploy:

- Create a new module variable `subnet_config` in the module that receives subnet CIDR blocks and Availability Zones
  from the user.
- Adjust the module block in the root configuration to add an entry for a single subnet using the CIDR block
  `10.0.0.0/24` and a valid AZ for the region you are working with.
- Implement a new resource within the module to create the actual subnets using a `for_each` loop and the
  `subnet_config` variable.

--- 

## Step-by-Step Guide

- In the module, create a new variable `subnet_config`, which will be of type map of objects, since we want the user to
  be able to create multiple subnets. Maps allow the user to specify keys, that then can be later used to retrieve the
  subnet information predictably. The objects should contain the following properties:

  ```hcl
  # cidr_block which receives the CIDR block of the respective subnet. 
  variable "subnet_config" {
    type = map(object({
      cidr_block = string
    }))
  
    validation {
      condition = alltrue([
        for config in values(var.subnet_config) : can(cidrnetmask(var.subnet_config.cidr_block))
      ])
      error_message = "The cidr_block config option must contain a valid CIDR block."
    }
  }
  ```

- Adjust the module block in our root configuration to add an entry for a single subnet. You can use `10.0.0.0/24` as
  the subnet CIDR block. Make sure that there are no errors by running a `terraform plan`.

```hcl
module "vpc" {
  source = "./modules/networking"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "13-local-modules"
  }

  # passing variable values to inner module and the passed 
  # variables will be used as module inner resources' initialization 
  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.0.0/24"
    }
  }
}
```

- Extend the `subnet_config` variable to also receive the Availability Zone as a property of the subnet objects, and
  adjust the module block to add a valid Availability Zone to `subnet_1`.

```hcl
variable "subnet_config" {
  type = map(object({
    cidr_block = string
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

- Create a new resource within the module to create the actual subnets. Leverage the `for_each` loop and the variable we
  have just created.
```hcl
resource "aws_subnet" "this" {
  for_each          = var.subnet_config
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr_block

  tags = {
    Name = each.key
  }
}
```
- Make sure that the subnet will actually be created by running a `terraform plan` and confirming that one resource is
  planned to be created.
- Make sure to destroy the resources after you complete all the steps!

