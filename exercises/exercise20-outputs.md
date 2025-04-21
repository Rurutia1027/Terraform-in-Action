# Working with Outputs

## Introduction

In this exercise, we will explore how to work with outputs in Terraform. Outputs are a way to expose data about our
resources and modules, and can be very helpful in understanding the state of our resources or integrating with other
systems. We will be defining locals, setting up an S3 bucket, and creating an output for the bucket name. We will then
run and inspect the output in the terminal and learn how to retrieve the output value outside of Terraform. Let's get
started!

--- 

## Step by Steep Guide

- Make sure that you have the locals defined according to previous exercises.
    ```hcl
    locals {
      project = "08-input-var-locals-outputs"
      project_owner = "terraform-course"
      cost_center = "2345"
      managed_by = "Terraform"
    }
  
    locals {
      common_tags = {
         project = local.project 
         project_owner = local.project_owner 
         cost_center = local.cost_center 
         managed_by = local.managed_by 
         sensitive_tag = var.my_sensitive_value      
      }      
    }
    ```
- Also make sure that the S3 bucket is correctly setup, together with a `random_id` for the suffix. We can comment out
  the EC2 instance code so that the terraform apply command completes faster.
  ```hcl
    # s3.tf 
    resource "random_id" "project_bucket_suffix" {
      byte_length = 4  
    }
     
    resource "aws_s3_bucket" "project_bucket" {
      bucket = "${local.project}-${random_id.project_bucket_suffix.hex}"
      tags = merge(local.common_tags, var.additional_tags) 
    }
  ```
- Create an output named `s3_bucket_name` to output the bucket name. Add a suitable description to the output.
  ```hcl
    output "s3_bucket_name" {
      value = aws_s3_bucket.project_bucket.bucket 
      description = "The name of the S3 bucket"  
    }
  ```
- Run and confirm a terraform apply command, and inspect what is output `<output name>`. In our case, this would be
  `terraform output s3_bucket_name`.
    - We can also add a `-raw` flag to omit the double quotes, so that the value of the output can be used in other
      shell commands.