resource "aws_instance" "web" {
  # https://cloud-images.ubuntu.com/locator/ec2/
  # ubuntu ami: ami                         = "ami-0da9e85793f872825"

  # nginx ami free tier AMI = "ami-0dfee6e7eb44d480b"
  ami                         = "ami-0dfee6e7eb44d480b"
  associate_public_ip_address = true
  instance_type               = "t2.micro"

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.public_http_traffic.id]

  root_block_device {
    # whenever current scoped resources are destroyed or terminated by terraform
    # the root block device will be deleted too
    delete_on_termination = true
    volume_size           = 10 # GB
    volume_type           = "gp3"
  }

  tags = merge(local.common_tags, {
    Name = "06-resoruces-ec2"
  })

  lifecycle {
    # In Terraform, Create Before Destroy refers to a behavior where Terraform ensures that a new resource is created
    # before an existing one is destroyed. This is commonly used to minimize downtime or ensure uninterrupted service
    # during infrastructure updates
    create_before_destroy = true
  }
}

resource "aws_security_group" "public_http_traffic" {
  description = "Security group allowing traffic on port 443 and 80"
  name        = "public_http-traffic"
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "06-resources-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  # anywhere is ok
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  # anywhere is ok
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

# exposing 22 for SSH connection is not suggested declared in security ingress_rule there are more recommended solutions
