# AWS Notes: AMI & Stack

- **Stack**: In AWS, a Stack refers to a collection of AWS resources that can be managed as a single unit.
    - Typically associated with **AWS CloudFormation**.
    - Example: A stack might include an EC2 instance, an S3 bucket, and a security group, all defined together.
- **AMI**: **AMI** is for **Amazon Machine Image**, a template that contains the operating system, application server,
  and applications required to launch an EC2 instance. 
- **Relationship** between **Stack** and **AMI**
  - A stack may include resources that use an AMI, such as EC2 instances. 
  - Example: In Cloud Formation, we can define an EC2 instance to use a specific AMI ID.  

### Key Points
- **AMI**: 
  - Acts as the base image for launching EC2 instances. 
  - A stack might reference AMIs to ensure consistent instance provisioning. 
- **Stack**: 
  - A broder concept managing groups of resources. 
  - Can include multiple instances using the same of different AMIs. 

### Examples 
```hcl
data "aws_ami" "latest" {
  most_recent = true 
  owners = ["amazon"]
  filters = {
    name= "amzn2-ami-hvm-*-x86_64-gp2"
  }
}

resource "aws_instance" "example" {
  ami = data.aws_ami.latest.id 
  instance_type = "t2.micro"
}
```