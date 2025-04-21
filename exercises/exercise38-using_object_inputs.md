# Migrating to Using Object Variables

## Introduction

In this exercise, you will be working on migrating to use object variables in a Terraform module. You'll start by
creating a new `aws_vpc` resource within the module, using a `vpc_cidr` variable to provide the CIDR block of the VPC.
You'll then add tags to the created VPC, and run a `terraform apply` operation. Following this, you'll modify the
`vpc_cidr` variable to become an object that receives both the VPC CIDR block and VPC name, to ensure a successful
migration without introducing any changes to the infrastructure. This exercise provides a practical demonstration of how
to handle variable migrations in Terraform, allowing you to handle complex configurations with ease.
--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and solution videos, here is an overview of
what the created solution should deploy:

- Create a new `aws_vpc resource within the module. Leverage the `vpc_cidr` variable to provide the CIDR block of the
  VPC.
- Add sensible tags to the created VPC, including the `Name` tag.
- Migrate the variable `vpc_cidr` to an object that receives both the VPC CIDR block and VPC name, and migrate the code
  without introducing any changes to the infrastructure.

--- 

## Step by Step Guide

- Create a new `aws_vpc` resource within the module. Use the `vpc_cidr` variable to provide the CIDR block of the VPC.
- Add tags to the created VPC, including the `Name` tag to be added to the VPC.
- Run a `terraform apply` and inspect that the VPC will be created. Confirm the operation and verify that the VPC is
  successfully created.
- Migrate the variable `vpc_cidr` to be an object that receives both the VPC CIDR block and VPC name. Rename the
  variable to be more suiting to the properties it contains.

```hcl
variable "vpc_config" {
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The cidr_block config option must contain a valid CIDR block"
  }
}
```

- Also, make sure to refactor the `aws_vpc` resource to correctly reference the values received via the new variable.
  THe code calling the module also needs to be refactored.

```hcl
# 13-local-modules/modules/networking/vpc.tf 

resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block

  tags = {
    Name = var.vpc_config.name
  }
}

# ---

# 13-local-modules/networking.tf 
module "vpc" {
  source = "./modules/networking"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "13-local-modules-exe38"
  }
}
```

- Confirm that we did not introduce any unwanted changes by running a `terraform plan` command and confirm that there
  are no changes to the infrastructure.
- Make sure to destroy the resources after you complete all the steps!