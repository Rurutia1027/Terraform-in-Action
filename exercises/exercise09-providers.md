# Working with Providers

## Introduction

In this exercise, we will explore the concept of the Providers in Terraform, specifically focusing on AWS providers. We
will learn how to configure multiple instances of AWS providers, each targeting a different region. By the end of this
exercise, you will be able to deploy resources in different AWS regions using separate provider instances. Let's get
started!


---

## Desired Outcome

If you wish to give it a shot before looking into detailed step-by-step and the solution videos, here is an overview of
what the created solution should deploy:

* Configure the default AWS providers to use the region of your choice(`eu-west-1` in this case).
* Configure another instance of the AWS provider with the region set to `us-east-1` and an alias of `us-east`.
* Create an S3 bucket resource in the `eu-west-1` region.
* Create an S3 bucket resource in the `us-east-1` region.

--- 

## Step-by-Step Guide

- Within your Terraform project folder, create a file `provider.tf` and declare the required Terraform version and the
  AWS provider source and version in a `required_providers` block within a `terraform` block:
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

- Configure the default `aws` provider to use the region of your choice (in my case, this is `eu-west-1`):
  ```hcl
   provider "aws" {
       region = "eu-west-1"  
   }
  ```

- Configure another instance of the `aws` provider by adding another `provider` block and setting the region to
  `us-east-1`. Also assign it to an alias so that it can be later used with resources:
  ```hcl
    provider "aws" {
         region = "us-east-1"
         alias = "us-east"
    }
  ```

- Create an S3 bucket resource in the `eu-west-1` region:

 ```hcl
  resource "aws_s3_bucket" "eu_west_1" {
  bucket = "some-random-bucket-name-test1"
}
 ```

- Create another S3 bucket in the `us-east-1` region. This time, specify the provider by using the alias you created
  earlier and passing it to the `provider` argument of the resource:

 ```hcl 
  resource "aws_s3_bucket" "eu_east_1" {
  bucket   = "some-random-bucket-name-test2"
  provider = aws.us-east
}
 ```

- Initialize Terraform in your project directory using the command `terraform init`.
- Validate your configuration using the command `terraform validate`.
- If the configuration is valid, apply it using the command `terraform apply`.
- Use the AWS console or CLI to check that resources were correctly deployed in both regions.
- Make sure to destroy the resources after your complete all the steps.

---