variable "subnet_count" {
  type    = number
  default = 2
}


variable "ec2_instance_config_map" {
  type = map(object({
    instance_type = string
    ami           = string
  }))

  default = {}
}

