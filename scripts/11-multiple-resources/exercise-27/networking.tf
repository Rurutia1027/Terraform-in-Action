locals {
  project = "11-multiple-resources-exercise27"
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Project = local.project
    Name    = local.project
  }
}

resource "aws_subnet" "main" {
  count  = var.subnet_count
  vpc_id = aws_vpc.main.id
  # cidr_block = "10.0.0.0/24" ; "10.0.1.0/24"; "10.0.2.0/24" ; "10.0.3.0/24"
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Project = local.project
    Name    = "${local.project}-${count.index}"
  }
}