# Using the AWS EC2 Module

## Introduction

In this exercise, we will learn how to use the AWS EC2 Module in Terraform. We will refactor some of the VPC module
information, introduce additional locals, and utilize the `data` block to get information about the most recent Ubuntu
22.04 Amazon Machine Image (AMI). We will then create an Amazon EC2 instance using the
`terraform-aws-modules/ec2-instance/aws` modules from the Terraform Registry. This exercise provides an excellent
opportunity to get hands-on experience with the AWS EC2 module and understand its functionality in a real world
scenario.

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created should deploy:

- Refactor the VPC module information to extract it to local blocks.
- Create additional `project_name` and `common_tags` locals in a shared file, to be used by other resources.
- Use the `data` block to get information about the most recent Ubuntu 22.04 Amazon Machine Image (AMI).
- Create an Amazon EC2 instance using the `terraform-aws-modules/ec2-instance/aws` module from the Terraform Registry.
  This include specifying the name, AMI, instance type, security group, and subnet for instance. Make sure to leverage
  the VPC module we have created in the previous exercise.

--- 

## Step-by-Step Guide

- Refactor the VPC module implementation to extract the VPC CIDR, public and private subnets, and the VPC name into
  their own locals. Place the VPC name in a `project_name` local in a shared file, since it will also be used by other
  resources.

  ```hcl
  # shared_data.tf 
  locals {
    project_name = "12-public-modules-exercise36"
  }
  
  # --- 
  
  # networking.tf 
  locals {
    vpc_cidr = "10.0.0.0/16"
    private_subnet_cidrs = ["10.0.0.0/24"]
    public_subnet_cidrs = ["10.0.128.0/24"]
  }
  
  data "aws_availability_zones" "azs" {
    state = "available"
  }
  
  module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.5.3"
  
    cidr            = local.vpc_cidr
    name            = local.project_name
    azs             = data.aws_availability_zones.azs.names
    private_subnets = local.private_subnet_cidrs
    public_subnets  = local.public_subnet_cidrs
  }
  ```

- Create a `common_tags` local in the shared file, and pass it to the existing VPC module.

  ```hcl
  # shared_data.tf 
  locals {
    project_name = "12-public-modules-exercise36"
    common_tags = {
      Project   = local.project_name
      ManagedBy = "Terraform"
    }
  }
  ```

- In the `compute.tf` file, declare a `locals` block containing the `instance_type` variable. The variable defines the
  type of Amazon EC2 instance that you want to launch.

  ```hcl
  locals {
    instance_type = "t2.micro"
  }
  ```

- Use the `data` block to get information about the most recent Ubuntu 22.04 Amazon Machine Image (AMI). The `owners`
  argument specifies the AWS account ID of the image owner. The `filter` arguments specify the name and virtualization
  type of the AMI.
  ```hcl
  data "aws_ami" "ubuntu" {
    most_recent = true 
     owners      = ["099720109477"] # Canonical

   filter {
     name   = "name"
     values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
   }

   filter {
     name   = "virtualization-type"
     values = ["hvm"]
   }
  }
  ```
- Use the `module` block to create an Amazon EC2 instance using the `terraform-aws-modules/ec2-instance/aws` module from
  the Terraform Registry. Specify the name, AMI, instance type, security group, and subnet for the instance based on the
  information from above, as well as from the VPC module that was created in the previous exercise. Use the default
  security group ID from the VPC module. Also, add your common tags to the instance.

  ```hcl
  moduel "ec2" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    version = "5.6.1"
  
    name          = local.project_name
    ami           = data.aws_ami.ubuntu.id
    instance_type = local.instance_type
    vpc_security_group_ids = [module.vpc.default_security_group_id]
    subnet_id     = module.vpc.public_subnets[0]
  
    tags = local.common_tags
  }
  ```

- Make sure to destroy the infrastructure at the end of the exercise. 