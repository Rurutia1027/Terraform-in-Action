# Creating Our First VPC Module

## Introduction

In this exercise, we will start creating out first Virtual Private Cloud (VPC) module using Terraform. We will continue
its implementation throughout the next few exercises. This module will provide a flexible, reusable ans standardized
approach to managing our network infrastructure. We will cover all the elements necessary to build the module, including
the creation of a CIDR block variable with validation and the use of the module in a root configuration. By the end of
the exercise, we will have created a reproduction piece of code that can be used to deploy a VPC consistently.
---

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

- Create a new folder `13-local-modules` for this project.
- Create a new module under the `13-local-modules/modules/networking` folder following the standard module structure:
  - `variables.tf`
  - `outputs.tf`
  - `provider.tf`
  - `main.tf (vpc.tf)`
  - LICENSE
  - README.md
- Create a variable `vpc_cidr` of type string and add validation to ensure the received CIDR block is valid.
- Create a new file `networking.tf` under the root configuration folder `13-local-modules`, which uses the module we
  just created.

--- 

## Step-by-Step Guide 

- Create a new folder named `13-local-modules` where we will place our module code.
- Create a new folder called `modules`, and under this folder, another folder named `networking`. This follows the
  convention of placing modules under a `modules` folder, and then using a single folder per module.
- Create the files for the standard module structure:
  - A `variable.tf` file to define the variables that module should receive.
  - An `output.tf` file to define the outputs provided by the module.
  - A `provider.tf` file to specify the module's dependencies.
  - A `main.tf` file (or `vpc.tf`) to host the resources we will create.
  - A `LICENSE` file as a placeholder for later definition of the license for the module.
  - A `README.md` file as a placeholder for later documentation of the module.
- Inside the module, create a variable `vpc_cidr` of type string and with a validation to check that the received CIDR
  block is valid.

  ```hcl
  variable "vpc_cidr" {
    type = string
  
    validation {
      condition = can(cidrnetmask(var.vpc_cidr))
      error_message = "The vpc_cidr must contain a valid CIDR block."
    }
  }
  ```

- Create a new file `networking.tf` under the root module `13-local-modules`, and use the module we have just created.

  ```hcl
  module "vpc" {
    source   = "./module/networking"
    vpc_cidr = "10.0.0.0/16"
  }
  ```

- Make sure to run `terraform init` after adding the module so that the module is installed.
- Run a `terraform plan` and inspect whether there are any errors. No infrastructure will be created yet, but if there
  are no errors, ,it means you successfully added the module to your root configuration.
- Make sure to destroy the resources module to your root configuration. 
