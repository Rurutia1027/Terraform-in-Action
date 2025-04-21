# exercise-29's EC2 instance initialization is different from exercise-28
# in exercise-28 all EC2 instances' parameters are build from count this variable
# but in exercise-29 we only focus on how to use the list to replace the count variable


locals {
  ami_ids = {
    ubuntu = data.aws_ami.ubuntu.id
  }
}

# datasource usage is the same
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "from_list" {
  # length of the array of ec2_instance_config_list is how many EC2 instances we gonna create in exercise 29 terraform project
  count         = length(var.ec2_instance_config_list)
  ami           = local.ami_ids[var.ec2_instance_config_list[count.index].ami]
  instance_type = var.ec2_instance_config_list[count.index].instance_type
  subnet_id = aws_subnet.main[
    count.index % length(aws_subnet.main)
  ].id

  tags = {
    Name    = "${local.project}-${count.index}"
    Project = local.project
  }
}