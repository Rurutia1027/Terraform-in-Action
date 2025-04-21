# actually this is not a valid HCl configuration file
# in it records different syntax like variables, data, locals, output concpets and how to declare of them
# do not try to terraform init/apply/destroy it
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.37.0"
    }
  }
}


# Actively managed by us, by our Terraform project
# first "" is the aws or provider's resource type;
# second "" is the label we set to the instance of the corresponding resource type.

## Actively managed by us, by our Terraform Project
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

# Managed somewhere else, we just want to use it in our project
# first "" after data is the resource type that we're going to retrieve
# second element "" is the label

# here pay a attention to the keyword of 'data'
# data(source) syntax in Terraform is used to retrieve information from remote APIs

## Managed somewhere else, we just want to use it in our Terraform Project.
data "aws_s3_bucket" "my_external_bucket" {
  bucket = "not-managed-by-us"
}


# We can provide variables to our configuration
# We can think variable as function parameters

# Variables can be updated or modified during the process of init/apply,
# and they also can be updated in the running time of current Terraform Project,
# which can introduce flexibility to our Terraform Project, such as when current Terraform interact with remote APIs and retrieve some resource name or status
# the variables can hold the return value and handover it to other components.
# Use the project inner defined variable by using `var`.`variable name`
variable "bucket_name" {
  type        = string
  description = "My variable used to set bucket name"
  default     = "my_default_bucket_name"
}


# Similarly, we can also expose information to the external world by using the keyword of 'output' block.
# the first parameter/element after the keyword of output is the label we set to this output item
# inside the output we can create a value which it's 'value' can come from either the 'resource' or 'data' or even the variables if you want to .
output "bucket_id" {
  value = aws_s3_bucket.my_bucket.id
  # value can also retrieve the inner value of the variable like this:
  # value = var.bucket_name
  # but we cannot create two value items in the scope of the output block
}

# declare local variables names and value
# sometime we need to do something like processing or filtering the inner data structures
# so that we can have some information simpler and easier to obtain
# that's the reason we use locals, it just like alias a complex expression
# like aws_s3_bucket.my_bucket.id it need to so complex and embedded structure expression and easy to error spelling
locals {
  local_example = "This is a local variable"
  key           = "test"
}

# module is a piece of re-usable code that we then import or into our project
module "my_module" {
  # here we need to delcare the source which means where we are importing this from

  # in this expression, we delcare a local modules by path
  source = "./module-example"
}