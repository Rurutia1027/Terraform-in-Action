# 1. Plan terraform init
# 2. Apply terraform apply
# 3. Destroy terraform destroy

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider Configuration
provider "aws" {
  region = "ap-southeast-1"
}

# VPC
resource "aws_vpc" "fullstack-app-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "SpringBoot-React-Fullstack"
  }
}

# Subnet
resource "aws_subnet" "fullstack-app-public-subnet" {
  vpc_id                  = aws_vpc.fullstack-app-vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Fullstack App Public Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "fullstack-app-igw" {
  vpc_id = aws_vpc.fullstack-app-vpc.id
  tags = {
    "Name" = "Fullstack App Internet Gateway"
  }
}

# Route Table
resource "aws_route_table" "fullstack-public-route-table" {
  vpc_id = aws_vpc.fullstack-app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fullstack-app-igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "fullstack-app-public-subnet-association" {
  subnet_id      = aws_subnet.fullstack-app-public-subnet.id
  route_table_id = aws_route_table.fullstack-public-route-table.id
}

# Security Group
resource "aws_security_group" "fullstack-ec2-sg" {
  vpc_id      = aws_vpc.fullstack-app-vpc.id
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "SpringBoot-React-Fullstack Security Group"
  }
}

# Launch Template
resource "aws_launch_template" "springboot-react-fullstack-lt" {
  name_prefix   = "fullstack-"
  image_id      = "ami-0046702f05be7acc8"
  instance_type = "t2.micro"

  network_interfaces {
    security_groups             = [aws_security_group.fullstack-ec2-sg.id]
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.fullstack-app-public-subnet.id
  }

  key_name = "fullstack-key-pair"
  tags = {
    "Name" = "Fullstack Docker Launch Template"
  }
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "springboot-react-fullstack" {
  name        = "SpringBoot-React-Fullstack"
  description = "Elastic Beanstalk Application for SpringBoot React Fullstack Microservice"
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "eb-env" {
  depends_on = [
    aws_vpc.fullstack-app-vpc,
    aws_subnet.fullstack-app-public-subnet,
    aws_security_group.fullstack-ec2-sg,
    aws_internet_gateway.fullstack-app-igw
  ]
  name                = "fullstack-eb-environment"
  application         = aws_elastic_beanstalk_application.springboot-react-fullstack.name
  solution_stack_name = "64bit Amazon Linux 2 v4.0.5 running Docker"

  # VPC Configuration
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.fullstack-app-vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", [aws_subnet.fullstack-app-public-subnet.id])
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = aws_subnet.fullstack-app-public-subnet.id
  }


  # Use Launch Template cause AWS no longer support Launch Configuration anymore (for new created envs)
  setting {
    namespace = "aws:autoscaling:launchtemplate"
    name      = "LaunchTemplateId"
    value     = aws_launch_template.springboot-react-fullstack-lt.id
  }

  setting {
    namespace = "aws:autoscaling:launchtemplate"
    name      = "LaunchTemplateVersion"
    value     = aws_launch_template.springboot-react-fullstack-lt.latest_version
  }

  # here we disable the autoscaling following the AWS's latest policy
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  # here we disable the autoscaling obey the AWS's latest policy
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }

  tags = {
    "Environment" = "Production"
  }
}
