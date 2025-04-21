# Using Data Sources to Fetch VPC Information

## Introduction

In this exercise, we will learn how to fetch information from a Virtual Private Cloud (VPC) that has been manually
created in the AWS console. This will be accomplished by using an `aws_vpc` data source block and specifying filter
criteria. This process will provide you with a hands-on understanding of how to retrieve and utilize data about existing
resources in your AWS infrastructure.


--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

* Manually create a Virtual Private Cloud(VPC) in the AWS console with the following configuration:
    * Name: console-managed
    * Environment(Env) tag: Prod
    * CIDR Block: 10.0.0.0/16
* Fetch the VPC information based on the `Env` tag via a `aws_vpc` data source block that specifies the correct filter
  criteria.

* Define an output to display `id` of the retrieved VPC.

--- 

## Step-by-Step Guide

### Creating a VPC in the Console

For us to be able to fetch information from a VPC managed outside our project, let's create one manually in the AWS
console:

- Log in to the AWS Management Console and navigate to the VPC Dashboard.
- Click on the "Your VPCs" link in the left-hand menu.
- Click the "Create VPC" button.
- Select the "VPC Only" option when AWS asks you whether to create only the VPC or also related resources.
- Add a `Name` tag with the value `console-mananged`.
- Add an `Env` tag with the value `Prod`.
- Set `10.0.0.0/16` as the CIDR Block.
- Leave the rest of the settings at their default values.
- Click the "Create" button.
- Your new VPC should now be visible in your VPCs list.

### Using Data Source to Fetch VPC Information

With the VPC created, we can now proceed to fetch its information using a data source in Terraform. A data source in
Terraform is a read-only access to existing resources in your infrastructure that might be managed outside of Terraform,
or that you only need for reference in your Terraform code.

- Define an `aws_vpc` data source block and specify the filter criteria to use the `Env` tag we have set in the previous
  section.

```hcl
data "aws_vpc" "prod_vpc" {
  tags = {
    Env = "Prod"
  }
}
```

- Define an output value that shows the `id` of the retrieved VPC.

```hcl
output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}
```

- Try to provide an non-existing value for the `Env` tag. What happens when we run a `terraform plan`?

```shell
Error: no matching EC2 VPC found 
... some error messages 
```

--- 