# Notes for Terraform Local _Module_

Module's definition: A module in Terraform is a reusable container for resources, and it can be used for both outputting
values and initializing resources.

## How A Module Declared and Used Demo

### First Define A Module

- The following hcl codes creates two EC2 instances with different AMIs and declares their security group IDs as output
  values.

```hcl
# ./modules/ec2/main.tf 

# EC2 Instance 1 with first AMI 

resource "aws_instance" "ec2_instance_1" {
  ami           = var.ami_id_1
  instance_type = "t2.micro"
  tags = {
    Name = "EC2 Instance 1 "
  }
}

# EC2 Instance 2 with second AMI
resource "aws_instance" "ec2_instance_2" {
  ami           = var.ami_id_2
  instance_type = "t2.micro"
  tags = {
    Name = "EC2 Instance 2 "
  }
}

# Output the security group ID of EC2 Instance 1 
output "ec2_instance_1_security_group_id" {
  value = aws_instance.ec2_instance_1.security_groups
}

# Output the security group ID of EC2 Instance 2 
output "ec2_instance_2_security_group_id" {
  value = aws_instance.ec2_instance_2.security_groups
}
```

### Define the Module's Inner Variables

_These variables(`variables.tf`)locates the same module path folder make sure Module inner defined resources can get
access to the variables via `var.xxx`_

```hcl
# ./modules/ec2/variables.tf 

variable "ami_id_1" {
  type        = string
  description = "AMI ID for EC2 Instance 1"
}

variable "ami_id_2" {
  type        = string
  description = "AMI ID for EC2 Instance 2"
}
```


### Then Use the Module

_This Module Invoker hcl file locates in the Root folder of current Terraform project_

```hcl
# main.tf in root module path

# Use the EC2 module to create instances 
module "ec2" {
  source   = "./modules/ec2"
  ami_id_1 = "ami-xxx" # AMI for aws ec2 instance 1
  ami_id_2 = "ami-xxx" # AMI for aws ec2 instance 2 
}

# Accessing outputs from the ec2 module and displaying them 
output "ec2_instance_1_security_group_id" {
  value = module.ec2.ec2_instance_1_security_group_id
}

output "ec2_instance_2_security_group_id" {
  value = module.ec2.ec2_instance_2_security_group_id
}
```


---

## Is the Module taking a referencing to the inner modules' instance ?

### Outputs Act as Getters

- The module itself does not expose the entire inner resources directly.
- Instead, you declare specific outputs inside the module to "get" or expose particular attributes(like the
  security_group, public_ip, etc) of the resource.

### No Instance Object Outside

- From outside the module, you cannot access the entire EC2 instance resource directly.
- You only interact with the values that are explicitly exposed through output blocks in the module.

### Getter Analogy in Java

- Just like in Java, where private fields are accessed via getter methods, Terraform modules allow access to internal
  resource properties only through output declarations. These outputs act as getters for specific fields.

### Outputs Must Be Declared Inside the Module

- If you need access to a field of a resource inside the module, you must define it as an output within the module.
  Otherwise, it cannot be accessed from outside.

--- 

