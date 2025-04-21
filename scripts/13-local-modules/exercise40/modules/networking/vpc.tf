data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block
}

resource "aws_subnet" "this" {
  for_each          = var.subnet_config
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr_block

  tags = {
    Name = each.key
  }

  lifecycle {
    precondition {
      # we need to validate the az(Availability Zone) field to ensure the provided initialization parameters are valid.
      # However, since the list of valid AZ values can only be retrieved dynamically during the `terraform apply` phase,
      # this validation cannot be handled using variable validation alone.

      # to address this, we use a lifecycle precondition along with a data source to fetch and validate the az values at runtime.
      # this ensures that valid AZ values are used during resource creation.
      condition = contains(data.aws_availability_zones.available.names, each.value.az)
      error_message = <<-EOT
      The AZ "${each.value.az}" provided for the subnet "${each.key}" is invalid.

      The applied AWS region "${data.aws_availability_zones.available.id}" supports the following AZs:
      [${join(", ", data.aws_availability_zones.available.names)}]
      EOT
    }
  }
}