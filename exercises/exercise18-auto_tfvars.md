# Working with `auto.tfvars`

## Introduction

In this exercise, you'll learn how to work with `auto.tfvars` in Terraform. This will involve creating and configuring a
`prod.auto.tfvars` file, which will be used to apply specific configurations when running Terraform in a production
environment. You'll also learn how Terraform automatically loads values from `*.auto.tfvars` files and how these values
can override those in

--- 

## Step-by-Step Guide

- First, create a new file called `prod.auto.tfvars`. This file will contain specific configurations that you want to
  apply when running Terraform in the production environment. Make sure that you also have a `terraform.tfvars` file
  with some default configuration.
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
- Inside `prod.auto.tfvars`, set the `ec2_instance_type` to `t3.large`. This setting specifies the type of EC2 instance
  that Terraform will deploy.
  ```hcl
   ec2_instance_type = "t3.large"
  ```

- Define the `ec2_volume_config` block. This block defines the configuration of the attached EBS volume. Set the `size`
  to `10` and `type` to `gp3`.

 ```hcl 
 ec2_volume_config = {
  size = 10
  type = "gp3"
}
 ```

- Finally, add the `additional_tags` block. This block allows you to add additional tags to your resources. The
  `ValuesFrom` tag is set to `prod.auto.tfvars`, indicating that the values are taken from the `prod.auto.tfvars` file.
  ```hcl
  additional_tags = {
    ValuesFrom = "prod.terraform.tfvars" 
  }  
  ```

- Save the `prod.auto.tfvars` file and run the `terraform plan` command. Which values are taken by Terraform.
- Delete the `prod.auto.tfvars` to prevent Terraform from automatically loading values from it in later plan and apply
  commands.

The `*.auto.tfvars` files are automatically loaded by Terraform when it runs. The values in the
`*.auto.tfvars` files override the values in the `terraform.tfvars` file. This means that if you have the same variable
defined in both the `terraform.tfvars` file and an `*.auto.tfvars` file, the value from the `*.auto.tfvars` file will be
used.

--- 