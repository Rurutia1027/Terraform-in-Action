variable "subnet_config" {
  type = map(object({
    cidr_block = string
  }))

  # add validation to ensure all string values of each cidr_block are satisfy net mask
  validation {
    condition = alltrue([
      for item in values(var.subnet_config) : can(cidrnetmask(item.cidr_block))
    ])

    error_message = "At least one of the provided CIDR blocks is not valid."
  }
}

variable "ec2_instance_config_list" {
  type = list(object({
    instance_type = string
    ami           = string
    # this is new added
    subnet_name = optional(string, "default")
  }))

  default = []

  validation {
    condition = alltrue([
      for config in var.ec2_instance_config_list : contains(["t2.micro"], config.instance_type)
    ])

    error_message = "Only t2.micro instances are allowed"
  }

  validation {
    condition = alltrue([
      for config in var.ec2_instance_config_list : contains(["nginx", "ubuntu"], config.ami)
    ])

    error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
  }
}


variable "ec2_instance_config_map" {
  type = map(object({
    instance_type = string
    ami           = string

    # new update fields for ec2 map applied instance's subnet field
    subnet_name = optional(string, "default")
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

