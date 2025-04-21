# Working with `tfvars`

## Introduction

In this exercise, we'll explore how to use `.tfvars` files in Terraform to manage and apply variable configurations.
We'll be creating files that contain variable configurations and then loading them into our Terraform plan. This is
a great way to manage different environments or stages in your infrastructure setup. The entire exercise should give you
a hands-on experience of working with `terraform.tfvars` files and how they can be used effectively to manage
configurations.

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and solution videos, here is an overview of
what the created solution should deploy:

- Create a `terraform.tfvars` file that contains configurations suitable for our defined variables.
- Rename the file to `dev.terraform.tfvars`, and check what happens when running Terraform commands.
- Create a new `prod.terraform.tfvars` file with different variable values should be created. We should be able to test
  loading this file into the Terraform plan and apply commands.

--- 

## Step-by-Step Guide

- Create a `terraform.tfvars` file with sensible values for the variables we have defined so far. It's important that
  the file is called `terraform.tfvars`, since Terraform automatically looks for this file.
  ```hcl
  ec2_instance_type = "t2.micro"
  
  ec2_volume_config = {
    size = 10 
    type = "gp2" 
  }
  
  additional_tags = {
    ValuesFrom = "terraform.tfvars"
  }
  ```
- Run the `terraform plan` and the `terraform apply` commands to make sure Terraform is correctly loading the values
  from the `terraform.tfvars` file.

- Now rename the file to `dev.terraform.tfvars` and re-run the `terraform plan` and `terraform apply` commands. Is
  Terraform able to load the values? Terraform does not automatically load `.tfvars` files with other names, but you can
  pass the `.tfvars` file to the `terraform plan` and `terraform apply` commands using the `-var-file=<filename>`
  option.

- Create a new `prod.terraform.tfvars` file. Set different values for the variables, and test how we can load this file
  into the `terraform plan` and `terraform apply` commands. Do not apply the configuration below, since it falls outside
  the free tier!
  ```hcl
    ec2_instance_type = "t3.large"
    ec2_volume_config = {
      size = 10 
      type = "gp3"
    }
  
    additional_tags = {
      ValuesFrom = "prod.terraform.tfvars" 
    }
  ```
- Make sure to destroy the resources after you complete all steps!