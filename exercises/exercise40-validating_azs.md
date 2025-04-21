# Validating the Availability Zones

## Introduction

In this exercise, we'll be focusing our attention on validating the Availability Zones (AZs) in the VPC module we are
implementing. By validating the AZs, we're able to ensure that we're utilizing the appropriate and available zones for
our project. The exercise involves creating a data source to retrieve available AZs, adding a precondition lifecycle
block to an AWS subnet resource, and crafting a user-friendly error message for invalid AZs.

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy.

- Create a data source `aws_availaiblity_zones.available`, which retrieves only the available Availability Zones (AZs)
  within the relevant region for our project.
- Add a `precondition` lifecycle block to the `aws_subnet.this` resource. This precondition check should ensure that the
  provided availability zone is included in the retrieved AZs from the data source created in the first step.
- Provide a user-friendly error message to inform the user in case an invalid availability zone is provided.

--- 

## Step-by-Step Guide

- Create a data source `aws_availability_zones.available`, which retrieves only the available AZs within the relevant
  region for our project.

  ```hcl
  data "aws_availability_zones" "available" {
    state = "available"
  }
  ```

- Add a `precondition` lifecycle block to the `aws_subnet.this` resource. In this precondition check, make sure that the
  provided availability zone is included in the retrieved AZs from the data source created in the previous step.

  ```hcl
  resource "aws_subnet" "this" {
    for_each          = var.subnet_config
    vpc_id            = aws_vpc.this.id
    availability_zone = each.value.az
    cidr_block        = each.value.cidr_block
  
    tags = {
      Name = each.key
    }
  
    lifecycle {
      precondition {
        condition = contains(data.aws_availability_zones.available.names, each.value.az)
        error_message = "Invalid AZ."
      }
    }
  }
  ```

- Write a user-friendly error message to inform the user in case an invalid availability zone is provided. Interpolate
  relevant values to the error message to make sure the user gets as much information as possible.

```hcl
resource "aws_subnet" "this" {
  for_each          = var.subnet_config
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr_block

  tags = {
    Name = each.key
  }

  lifecycle {
    precondition {
      condition = contains(data.aws_availability_zones.available.names, each.value.az)
      error_message = <<-EOT
      The AZ "${each.value.az}" provided for the subnet "${each.key}" is invalid.

      The applied AWS region "${data.aws_availability_zones.available.id}" supports the following AZs:
      [${join(", ", data.aws_availability_zones.available.names)}]
      EOT
    }
  }
}
```

- Make sure to destroy the resources after you complete all the steps!

## Notes for resource's `lifecycle precondition` and variable's `validation condition`

- Use variable **validations** to ensure valid input values during variable assignment.
- Use lifecycle **preconditions** to ensure resource conditions are met during the resource lifecycle. 