# Using Data Sources to Fetch AMI Information

## Introduction

In this exercise, we will be exploring the use of AWS data sources in Terraform to retrieve the most recent Ubuntu
Amazon Machine Image(AMI). We'll define an output variable to print the ID of the retrieved AMi and use this ID to
configure an AWS instance resource. This hands-on exercise is designed to give you practical experience in handling AWS
AMIs and configuring AWS instances using Terraform.

---

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

- Define an AWS data source to retrieve the most recent Ubuntu AMI.
- Create an output to print the ID of the retrieved AMI.
- Create an AWS EC2 instance, using the retrieved Ubuntu AMI ID. Use an instance type that is included in your free
  tier. Most of the time, this will be `t2.micro` instance, but it can also be `t3.micro` in regions that do not have
  `t2.micro` instances available. Make sure to check that beforehand to avoid any unwanted charges!
- Configure the instance's root block device with a volume size of 10, a volume type of `gp3`, and set it to be deleted
  on termination.

--- 

## Useful Resources

* AWS AMI Data Source -  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami

--- 

## Step-by-Step Guide

- First, define a data source to retrieve the most recent Ubuntu AMI from AWS. The owner of the AMI is Canonical, the
  company behind Ubuntu. We use filters to only retrieve the AMIs that match our criteria.
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Owner is Canonical

  # here we set filtering rule one upon all Canonical owned AMIs by the image's name 
  filter {
    name = "name" # filter by name 
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  # here we set filtering rule two upon all Canonical owned AMIs by the image's name 
  filter {
    name = "virtual" # filter by virtualization type
    values = ["hvm"]
  }
}
```

- Then, define an output variable to print the ID of the AMI we have retrieved.

```hcl
output "ubuntu_ami_data" {
  # use terraform output ubuntu_ami_data can print the filtered target AMI name on the console 
  value = data.aws_ami.ubuntu.id
}
```

- Finally, define an AWS instance resource. Use the ID of the Ubuntu AMI we have retrieved as the AMI for the instance.
  Specify the instance type to be `t2.micro`. Also specify the root block device configuration to have a volume size of
  10, a volume type of `gp3`, and set it to be deleted on termination.

```hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
}
```

- Run `terraform apply` to create the infrastructure. If everything is configured correctly, it should create a new
  `t2.micro` instance in your AWS account using the most recent Ubuntu AMI.

- Make sure to destroy the resources after you complete all the steps!

--- 

## Question: How to maintain the return value is single string not an array of matching filter condition string array?

### How `aws_ami` Data Source Works ?

The `aws_ami` data source in Terraform is designed to return only one AMI that matches the filters. The
`most_recent = true` setting ensures that it will pick the **latest** AMI from the results that satisfy the filters.

Here is why this avoids returning multiple values:

- `most_recent` Parameter:
  - This parameter tells Terraform to automatically select the single, most recently created AMI from the filtered
    results.
  - Without `most_recent`, the data source might indeed return multiple results, which could cause problems when you try
    to reference the id (or other attributes).

- Filters Narrow Down the Results:
  - The combination of owners and the two filter blocks further restricts the set of matching AMIs.
  - The **name** filter ensures it matches Ubuntu 22.04 server images.
  - The **virtual** filter ensures only AMIs using hvm virtualization are included.

- Internal Validation:
  - If the filters do not narrow down the results to a single AMI when `most_recent = true` is omitted, Terraform will
    raise an error.

--- 

## Question: We can use `terraform output` command after `terraform apply` or `terraform init` Why?

We can use `terraform output` command **after** **terraform apply** or (`terraform plan -out=<file>` and then
`terraform apply <file>`). Here's why:

### When terraform output works

- After `terraform apply`: The `terraform output` command retrieves values from the Terraform state file, which is only
  created or updated after a successful `terraform apply`(after the resources are applied via provider successfully will
  the state of the resources be written to the state files). At this point, the resources and their outputs are fully
  provisioned.

- After State Initialization(`terraform init`): While `terraform init` sets up Terraform's backend and downloads
  provider plugins, it doesn't create or update resources, so no state file with output exists yet. Consequently,
  `terraform output`will not return any meaningful results. Actually `terraform output` command is designed to output *
  *successfully applied resources**.   

### Typical Usage

```shell
# print specified output item content 
terraform output <output_name>

# print all current terraform project's output items 
terraform output 
```
