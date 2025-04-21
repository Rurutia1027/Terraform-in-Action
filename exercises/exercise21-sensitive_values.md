# Working with Sensitive Values

## Introduction

In this exercise, we will delve into the process of handling sensitive values in Terraform. We'll learn how to set
certain values as sensitive and how to retrieve them. Moreover, we'll understand the implications of setting a sensitive
value and how it impacts the logs output by Terraform. This hands-on exercise will provide you a practical understanding
of working with sensitive data, which is a crucial aspect of managing infrastructure.

--- 

## Step by Step Guide

- Let's start by setting the `s3_bucket_name` as sensitive by adding a `sensitive=true` to the output block.
  ```hcl
    output "s3_bucket_name" {
      value = aws_s3_bucket.project_bucket.bucket 
      sensitive = true 
      description = "The name of the S3 bucket" 
    } 
  ```
- Retrieve the value of the output with `terraform output s3_bucket_name`. As you can see, we have no problems
  retrieving the value of output set as sensitive.
- Create a variable called `my_sensitive_value` containing a sensitive value, and reflect this directly in an output
  named `sensitive_var`: 
  ```hcl
    variable "my_sensitive_value" {
      type = string 
      sensitive = true  
    }
  
    output "sensitive_var" {
       sensitive = true # we must set this to true since the variable is sensitive 
       value = var.my_sensitive_value
    }
  ```

