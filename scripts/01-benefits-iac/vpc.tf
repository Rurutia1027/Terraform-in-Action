# 1. Plan
# 2. Apply
# 3. Destroy


# config block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# config provider
provider "aws" {
  region = "ap-southeast-1"
}

# first, we create an instance of vpc
#  format after resource "${aws(provider's) resource name}" "the name you give to this to be created resource instance"
resource "aws_vpc" "tf-demo-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Terraform VPC"
  }
}

# then, we create two instances of subnets public subnet and private subnet
resource "aws_subnet" "tf-demo-public-subnet" {
  // this will bind current created public subnet instance to previous created aws_vpc
  vpc_id     = aws_vpc.tf-demo-vpc.id
  cidr_block = "10.0.0.0/24"
}
resource "aws_subnet" "tf-demo-private-subnet" {
  // this will bind current created private subnet instance to previous created aws_vpc
  vpc_id     = aws_vpc.tf-demo-vpc.id
  cidr_block = "10.0.1.0/24"
}

# then, we continue create an instance of aws's internet gateway
# and let the created internet gateway attach to the VPC that we previously created
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-demo-vpc.id
}

# then, we continue with creating route-table instance
resource "aws_route_table" "tf-public-rtb" {
  vpc_id = aws_vpc.tf-demo-vpc.id

  # inside of the route-table instance, we need to declare the route table content
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-igw.id
  }
}

resource "aws_route_table_association" "tf-public-subnet" {
  subnet_id      = aws_subnet.tf-demo-public-subnet.id
  route_table_id = aws_route_table.tf-public-rtb.id
}