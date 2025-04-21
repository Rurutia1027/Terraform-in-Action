variable "subnet_count" {
  type    = number
  default = 2
}


variable "ec2_instance_config_map" {
  type = map(object({
    instance_type = string
    ami           = string
  }))


  validation {
    condition = alltrue([
      for config in values(var.ec2_instance_config_map) : contains(["t2.micro"], config.instance_type)
    ])
    error_message = "Only t2.micro instances are allowed."
  }

  validation {
    condition = alltrue([
      for config in values(var.ec2_instance_config_map) : contains(["nginx", "ubuntu"], config.ami)
    ])
    error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
  }


  default = {}
}

