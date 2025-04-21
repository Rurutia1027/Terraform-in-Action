# data source 1
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical

  # filter rule 1: filter by pattern match AMI name
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  # filter rule 2: filter by AMI's virtualization type
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# data source 2
data "aws_caller_identity" "current" {}


# data source 3
data "aws_region" "current" {}

# data source 4
# we need an extra external terraform hcl script to create this vpc instance
# so that when current script is applied the vpc instance is already existing and we can use data source to fetch it
# data "aws_vpc" "prod_vpc" {
#   tags = {
#     Env = "Prod"
#   }
# }

# data source 4
data "aws_availability_zones" "available" {
  state = "available"
}

# data source 5
data "aws_iam_policy_document" "static_website" {
  statement {
    sid = "PublicReadGetObject"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]

    resources = ["arn:aws:s3:::*/*"]
  }
}

resource "aws_s3_bucket" "public_read_bucket2" {
  bucket = "my-public-read-bucket2"
}


# declare output item
# after executing terraform apply success
# use `terraform output iam_policy` can print the inner aws_iam_policy contents for static_website in json format to console
output "iam_policy" {
  value = data.aws_iam_policy_document.static_website.json
}

# show aws_availability_zones on console via terraform output azs command
output "azs" {
  value = data.aws_availability_zones.available
}

# output "prod_vpc_id" {
#   value = data.aws_vpc.prod_vpc.id
# }


output "ubuntu_ami_data" {
  value = data.aws_ami.ubuntu.id
}

# this will expose inner current aws_caller_identity content to output contents on console
output "aws_caller_identity" {
  value = data.aws_caller_identity.current
}

# this will expose inner current region value to output contents on console
output "aws_region" {
  value = data.aws_region.current
}

resource "aws_instance" "web" {
  # AMI ID NGINX  = ami-0dfee6e7eb44d480b
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"

  # allocate a piece of disk to active EC2 instance with disk space volume = 10 GB
  # and configure once the active EC2 is deleted or terminated via Terraform command
  # this piece of disk resource will be terminated or destroyed too
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3" # ssd type
  }
}