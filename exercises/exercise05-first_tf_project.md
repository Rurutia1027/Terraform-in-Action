# Our First Terraform Project

## Introduction

In this exercise, we will be creating our first project using Terraform, a popular infrastructure as Code tool. We will
be covering the basics of setting up a Terraform project, configuring the AWS provider, creating a random ID for
resource naming, creating an AWS S3 bucket, and outputting the bucket name. This will give you a hands-on introduction
to using Terraform to manage AWS resources. Let's get started!

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

* Set the Terraform version and specify the required providers (`random` and `AWS`).
* Configure the AWS provider to use the region you are using for the course.
* Create a Random ID for the AWS S3 bucket name.
* Create an AWS S3 bucket.
* Create an output block for the bucket name.

### Useful Resources

* [Terraform Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs).

---

## Step-by-Step Guide

* In the `terraform` block, specify the required Terraform version (`~> 1.7`). Additionally, define the required
  providers and their versions. In this case, we need the `aws` provider(`~> 5.0`) and the `random` provider(`~> 3.0`).
  ```hcl
  terraform {
    required_version = "~>1.7"
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
      random = {
        source = "hasihcorp/random"
        version = "~> 3.0"
      }
    }
  }
  ```

* Use the `provider` block to configure the AWS region to `ap-southeast-1`.
  ```hcl
  provider "aws" {
    region = "ap-southeast-1"
  }
  ```

* Create a `random_id` resource named `bucket_suffix` with a `byte_length` of 6. This ID will be used to create a unique
  name for the S3 bucket.
  ```hcl
  resource "random_id" "bucket_suffix" {
    byte_length = 6 
  }
  ```

* Create an `aws_s3_bucket` resource named `example_bucket`. Use interpolation to create a unique bucket named by
  appending the random ID "example-bucket-".
  ```hcl 
  resource "aws_s3_bucket" "example_bucket" {
    bucket = "example-bucket-${random_id.bucket_suffix.hex}"
  }
  ```

* Finally, use an `output` block to output the name of the created bucket.
  ```hcl
  output "bucket_name" {
     value = aws_s3_bucket.example_bucket.bucket 
  }
  ```

* After you've written the Terraform configuration, run the following Terraform CLI commands in your terminal:
    * `terraform init`: This command initialize your Terraform workspace by downloading the necessary provider plugins.
    * `terraform plan`: This command shows you what changes Terraform will make to your infrastructure without actually
      making them.
    * `terraform apply`: This command applies the changes, creating the infrastructure.
    * `terraform destroy`: When you're done with the infrastructure, use this command to remove all resources created by
      your Terraform configuration.  

