# Overview of the Hashcorp Configuration Language(HCL)

## Introduction

This exercise is focused on exploring the syntax of the HashiCorp Configuration Language(HCL). We will delve into how to
declare providers, define resource and data blocks, use variables and outputs, create local blocks, and include modules.
This exercise aims to give a comprehensive understanding of how to use HCL in configuring and managing your
infrastructure, but don't worry if there are points which are note clear. We will cover all of them in detail throughout
the course!

--- 

## Desired Outcome

If you wish to give a shot before looking into the detailed step-by-step and the solution videos, there is an overview
of what the created solution should deploy.
Check the "Useful Resources" section below for the HCL syntax documentation so that you can check the correct syntax for
each block.

* A declaration of required providers, specifically the AWS provider from HashiCorp.
* A `resource` block defining an AWS S3 bucket.
* A variable named `bucket_name`, which is used in the created `resource` block to define the bucket's name.
* An `output` block that outputs the ID of the managed AWS S3 bucket.
* A `locals` block defining a local variable named `local_example`.
* A module block that includes a module located in the `./module-example` directory.

### Useful Resources

* [Configuration Language Syntax](https://developer.hashicorp.com/terraform/language/syntax)

--- 

## Step-by-Step Guide

* Start by declaring your required providers. In this case, we are using the AWS provider, version `5.37.0`, sourced
  from HashiCorp. This block tells Terraform where to fetch the provider.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

* Next, define a resource block for an AWS S3 bucket that you want to manage with this Terraform script. The `bucket`
  argument is set to a variable which we will define later.

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}
```

* Define a data block for an AWS S3 bucket that is managed outside of this Terraform script. This allows us to fetch and
  use data about this external bucket.

```hcl
data "aws_s3_bucket" "my_external_bucket" {
  bucket = "not-managed-by-us"
}
```

* Define a `bucket_name` variable. This is used in the `resource` block to set the `bucket` argument.

```hcl
variable "bucket_name" {
  type        = string
  description = "My variable used to set bucket name"
  default     = "my_default_bucket_name"
}
```

* Define an output block to output the ID of the bucket that we are managing with this Terraform script.

```hcl
output "bucket_id" {
  value = aws_s3_bucket.my_bucket.id
}
```

* Define a local block to create a local variable. This variable is only available within this Terraform project.

```hcl
locals {
  local_example = "This is a local variable"
}
```

* Lastly, use a module block to include a module that is located in the `./module-example` directory.

```hcl
module "my_module" {
  source = "./module-example"
}

```

--- 

## My Notes of This Exercise

### Why Create the S3 Bucket ?

* `aws_s3_bucket.my_bucket`: This creates an S3 bucket that is **actively managed by this Terraform project**. Terraform
  will control its lifecycle, meaning it handles creation, updates, and deletion.
* **Purpose**:
    * It can be used to store data like logs, backups, or static website files.
    * In some Terraform setups, S3 buckets are also used as a *state backend** to store the Terraform state file.

* `aws_s3_bucket.my_external_bucket`: This is a **data source** used to reference an **already existing S3 bucket** that
  is **not managed by this Terraform project**. 
* **Purpose**: 
  * It allows the project to read metadata or use the external bucket as port of the infrastructure without managing it.

### Why Two S3 Buckets? 
There are two buckets for different purposes: 
* `aws_s3_bucket.my_bucket`:
  * Created and controlled by this Terraform project. 
  * Used for storing project-related data. 
* data `aws_s3_bucket.my_external_bucket`: 
  * References an external bucket that is managed by another team or created manually.
  * Used to read shared or external resources (e.g., shared configuration files or data sets).

* **Example**: 
  * The internal bucket is used for application logs. 
  * The external bucket is used for accessing shared files such as pre-trained ML models or configuration templates.  

### Purpose of Variables 
* variable "bucket_name":
  * This defines a variable for the bucket's name, which can be overridden when applying the configuration. 
  * If not value is provided the Terraform run, the default value (my_default_bucket_name) is used. 

### Purpose of local 
* locals **block**: 
  * **Defines local variables to simplify complex expressions or reduce repetition in the code**. 
* Example: 
  ```hcl 
  locals {
    example_url = "${var.bucket_name}.s3.amazonaws.com"
  }
  ```
  Declare like this so that you can reuse `local.example_url` instead of rewriting the full expression multiple times. 

### Purpose of the Module 
* module "my_module"
  * Represents a reusable block of Terraform code. 
  * The source field specifies the module's location, such as local directory (./module-example) or a remote source (like a GitHub repository or Terraform Registry). \
* **Purpose**:
  * **Reusability**: Allows the same logic to be reused in different environments or projects. 
  * **Simplification**: Organizes code into smaller, focused units. 
* Example
  ```hcl 
  module "network" {
    source = "./network-module"
    vpc_id = aws_vpc.main.id 
  }
  ```
  * A network module could handle creating a VPC, subnets, and other networking resources.

--- 

## What Happens if Referenced External Resource(here the S3 bucket) Not Exists

If that data block in Terraform does not create the resource -- it simply references an existing resource that must
already be created by someone else or by another process. If the external bucket reference in the data block does not
exist, Terraform will fail because it cannot find the resource.

In our case, if the external bucket (`not-managed-by-us`) hasn't been created by someone else or bu another process, we
won't be able to use the data `aws_s3_bucket` block successfully. We'd need to ensure that the bucket exists before
running Terraform, either by manually creating it or by coordinating with whoever manages that infrastructure. 

* Regarding dependencies in Terraform: 
  * Resources in Terraform can depend on each other explicitly through the use of outputs and inputs or implicitly through references in resource blocks. 
  * In this example, the external buckets does not create a dependency because it's only being referenced, not managed. 