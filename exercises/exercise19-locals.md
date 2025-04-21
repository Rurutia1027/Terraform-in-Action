# Working with Locals

## Introduction

In this exercise, we will be exploring the use of locals in Terraform. Locals provide a way to define a variable that
can be reused within your module without needing to pass it in as an input variable. Through a series of steps, you will
learn how to define locals, create a `common_tags` block, refactor an EC2 instance, create an S3 resource utilizing
locals, and move the locals block to its own file. This exercise will enhance your understanding of locals and how they
can be used to optimize your Terraform projects.

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

- Define the following locals with sensible values: `project`, `project_owner`, `cost_center` and `managed_by`.
- Create a `common_tags` local object, which references some of the previous locals to create an object.
- Refactor our EC2 instance to merge `local.common_tags` and `var.additional_tags` when setting its tags.
- Deploy an S3 resource that also uses values from our locals in its configuration.
- Move the locals block to its own file named `shared-locals.tf`.

--- 

## Step-by-Step Guide

- Define the following locals in an existing file by using the `locals` block: `project`, `project_owner`, `cost_center`
  and `managed_by`. Locals in Terraform are a way to define a variable that can be reused within your module without
  needing to pass it in as an input variable. You can place them in the `compute.tf` file to begin with.
    ```hcl
       locals {
         project = "08-input-vars-locals-outputs"
         project_owner = "terraform-course"
         cost_center = "1234"
         managed_by = "Terraform "
       } 
    ```

- Define a `common_tags` block that incorporates those values in an object-like structure.
    ```hcl
       locals {
         common_tags = {
           project = local.project 
           project_owner = local.project_owner 
           cost_center = local.cost_center 
           managed_by = local.managed_by  
         }
       } 
    ```

- Refactor the EC2 instance to merge the `local.common_tags` and the `var.additional_tags` when setting its tags.
  ```hcl
     resource "aws_instance" "compute" {
       ami = data.aws_ami.ubuntu.id 
       instance_type = var.ec2_instance_type 
  
       root_block_device {
         delete_on_termination = true 
         volume_size = var.ec2_volume_config.size 
         volume_type = var.ec2_volume_config.type  
       }
  
       tags = merge(local.common_tags, var.additional_tags)
     }
  ```
- Create an S3 resource that also leverage some values from out locals in its configuration.
  ```hcl
    resource "random_id" "project_bucket_suffix" {
      byte_length = 4  
    }
  
    resource "aws_s3_bucket" "project_bucket" {
      bucket = "${local.project}-${random_id.project_bucket_suffix.hex}"
      
      tags = merge(local.common_tags, var.additional_tags) 
    }
  ```

- Move the locals block to its own file named `shared-locals.tf`. **Notice that we don't need to explicitly import files
  in our Terraform projects**.

--- 