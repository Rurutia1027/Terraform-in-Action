# those variables already declared in variables.tf file
# and the values set in terraform.tfvars files will override the default values
# once values set in current terraform.tfvars files
# users no longer need to type the values on console during terraform apply stage

ec2_instance_type = "t2.micro"

ec2_volume_config = {
  size = 10
  type = "gp2"
}

my_sensitive_value = "secret"

additional_tags = {
  ValuesFrom = "terraform.tfvars"
}

