# here we set default value for subnet_config variable which defined in the file of variables.tf
subnet_config = {
  default = {
    cidr_block = "10.0.0.0/24"
  }

  subnet_1 = {
    cidr_block = "10.0.1.0/24"
  }
}

ec2_instance_config_map = {
  # key = ubuntu_1
  ubuntu_1 = {
    instance_type = "t2.micro"
    # ami's value is the key name locates in the ami_ids this local variable map
    ami = "ubuntu"
  }

  nginx_1 = {
    instance_type = "t2.micro"
    ami           = "nginx"
  }
}