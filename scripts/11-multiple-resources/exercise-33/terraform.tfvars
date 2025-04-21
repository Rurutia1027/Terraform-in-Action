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