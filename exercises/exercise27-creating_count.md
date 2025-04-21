# Creating Multiple Subnets with the `count` Argument

## Introduction

In this exercise, we'll delve into the creation of multiple subnets using the `count` argument in Terraform. This
exercise is designed to help you understand how to efficiently manage resources in Terraform and avoid code duplication.
You'll learn how to define a local variable, create a Virtual Private Cloud (VPC), and use the `count` meta-argument to
create multiple subnets. You'll also learn how to use the `tags` attribute to assign unique names to subnets using the
`count.index` value and make the count of subnets configurable by creating new `subnet_count` variables. This exercise
will provide a step-by-step guide on how to achieve these tasks.

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

- Create a Virtual Private Cloud(VPC) with a CIDR block set to `10.0.0.0/16`. The VPC is tagged with the `Project` and
  `Name` tags that hold the value of a newly created `local.project` local variable.
- Leverage the `count` meta-argument to create multiple subnets, reducing code duplication and making extension easier.
- Assign unique names to the subnets using the `count.index` value and the `tags` attribute.
- Create a new variable `subnet_count` to replace the hard-coded count value in the `aws_subnet` resource, thereby
  making the count of subnets configurable.

## Step-by-Step Guide

- Create a new `networking.tf` file, and define a local variable to store the `project` we are working on. This will
  help to keep your code neat and reusable. For this exercise, we have a project variable with the value
  `11-multiple-resources`.

  ```hcl
  locals {
    project = "11-multiple-resources"
  }
  ```
- Create a Virtual Private Cloud (VPC) by defining a resource of type `aws_vpc`, and set the CIDR block to
  `10.0.0.0/16`. Add two tags, `Project` and `Name`, that hold the value stored in the `local.project` local variable.

  ```hcl
  resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
  
    tags = {
      Project = loca.project
      Name    = local.project
    }
  }
  ```

- Create two subnets by adding two `aws_subnet` resources.

  ```hcl
  resource "aws_subnet" "subnet1" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "10.0.0.0/16"
  
    tags = {
      Project = local.project
      Name    = local.project
    }
  }
  
  resource "aws_subnet" "subnet2" {
    vpc_id     = aws_vpc.main.id
    cidr_block = "10.0.1.0/16"
  
    tags = {
      Project = local.project
      Name    = local.project
    }
  }
  ```

- While this works, is has a lot of duplication, and it's not easy to extend. Let's try to use the `count` meta-argument
  to create multiple subnets. Remove the `subnet2` entry, and change the `subnet1` to include a `count=2` meta-argument.
  Rename the resource to `aws_subnet.main` instead of `aws_subnet.subnet1`.

  ```hcl
  resource "aws_subnet" "main" {
    count      = 2
    vpc_id     = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
  
    tags = {
      Project = local.project
      Name    = "${local.project}-${each.index}"
    }
  }
  ```

- Try to apply this configuration. Does it work ? Which error do we get back?
- For the subnets to be successfully created, we must ensure that the CIDR blocks are not overlapping with each other.
  We can leverage the `count.index` value that becomes available whenever we use the `count` meta-argument. Update the
  `cidr_block` of the subnet to `"10.0.${count.index}.0/24""`, where `${count.index}` is the index of the current
  iteration, allowing for a unique CIDR block for each subnet. The `tags` attribute isused to assign names to the
  subnets, and you can also leverage `count.index` there to uniquely identify each subnet.

  ```hcl
  resource "aws_subnet" "main" {
    count      = 2
    vpc_id     = aws_vpc.main.id
    cidr_block = "10.0.${count.index}.0/24"
  
    tags = {
      Project = local.project
      Name    = "${local.project}-${count.index}"
    }
  }
  ```

- Last but not least, create a new variable `subnet_count` and migrate away from the hard-coded count value in the
  `aws_subnet` resource.
```hcl
variable "subnet_count" {
  type    = number
  default = 2
}

resource "aws_subnet" "main" {
  count      = var.subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Project = local.project
    Name    = "${local.project}-${count.index}"
  }
}
```