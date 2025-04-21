variable "subnet_count" {
  type    = number
  default = 2
}

variable "ec2_instance_count" {
  type    = number
  default = 3
}


# in terraform.tfvars this variable is initialized
# see terraform.tfvars for more details
variable "ec2_instance_config_list" {
  # here we create a list of object
  # and the inner object type is declared with two required fields one is the instance_type in string
  # the other is defined in the type in string as ami


  type = list(object({
    instance_type = string
    ami           = string
  }))

  # here declare the default value of the object array as empty list/array

  default = []
}

