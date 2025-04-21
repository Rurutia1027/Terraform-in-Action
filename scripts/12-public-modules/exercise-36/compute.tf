locals {
  instance_type = "t2.micro"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.0"

  name          = local.project_name
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  # here we take a reference to the already module created resource of VPC's inner attributed of security group id
  # as the input parameter to apply resources for ec2 instance
  vpc_security_group_ids = [module.vpc.default_security_group_id]

  # ec2 instance's subnet_id's value also coming from module based subnet id value
  subnet_id = module.vpc.public_subnets[0]

  tags = local.common_tags
}
