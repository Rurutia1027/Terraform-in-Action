# Receiving the AWS Region via Variables

## Introduction

In this exercise, we will explore how to receive the AWS Region using variables in Terraform. This will allow us to
dynamically set the region in which our resources will be created. However, it's important to note that this approach
comes with its own set or challenges, and we need to be aware of this potential pitfalls. The exercise will guide you
through creating and applying Terraform configuration files, and observing the behavior when changing the region. By the
end of the exercise, you'll have a deeper understanding of how Terraform handles regions, instances, and the importance
of carefully managing your resources.

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

- Create a `variables.tf` file with a single variable named `aws_region`.
- Create a `provider.tf` file with the standard configuration code we have been using so far (Terraform required version
  and the AWS provider requirements).
    - Use the `aws_region` variable to set the region for configuring the `aws` provider.
    - Create an EC2 instance using the `aws_ami` data source for the Ubuntu AWS AMI.

--- 

## Step-by-Step Guide

- Create a `variable.tf` file and declare a single variable named `aws_region`. If you do not assign a default value to
  the variable, you'll need to provide the value when you run Terraform commands.
  ```
  aws_region="eu-west-1"
  ```
- Create a `provider.tf` file and add the standard configuration code we have been using for our Terraform projects.
  ```hcl
  terraform {
    required_version = "~> 1.7"
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }    
  }
  ```
- Use the `aws_region` variable to set the region of the `aws` provider.
  ```hcl
   provider "aws" {
       region = var.aws_region 
   }
  ```
- This pattern is very dangerous! Can you guess why ? Let's create an EC2 instance to check what can go wrong here.
  Create a data source to retrieve the Ubuntu AWS AMI, and an EC2 instance, as we have done in previous sections.
  ```hcl
  data "aws_ami" "ubuntu" {
    most_recent = true 
    owners = ["099720109477"] # Owner is Canonical
  
    filter {
       name = "name"
       values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
    }
  
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
  }
  
  resource "aws_instance" "compute" {
    ami = data.aws_ami.ubuntu.id 
    instance_type = "t2.micro"
    
    root_block_device {
      delete_on_termination = true 
      volume_size = 10
      volume_type = "gp3"
    }  
  }
  ```
- Now run the `terraform apply` command and pass the region you have been working on so far as a value to the created
  variable. Everything should work as expected.
- Run the `terraform plan` command, but now pass a different region. What happens as a result ? Does Terraform plan to
  destroy the previous created EC2 instance? How many instances would exist in each region if you were to apply this
  plan?
- As you can see, Terraform **will not destroy** previously created instances in another region! This can lead to many
  resources being simply "forgotten" by Terraform, which can be very troublesome(like the Wild Pointer in C/C++).
- As a final step, remove the `aws_region` variable and hard-code the correct region in the `provider "aws"`
  configuration block.
- Make sure to destroy the resources after you complete all the steps. 



