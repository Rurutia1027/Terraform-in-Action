# Using Data Sources to Fetch AWS Callers Identity and Region

## Introduction

In this exercise, we will be focusing on understanding and utilizing the AWS Caller Identity and AWS Region Data
Sources. The aim is to define data sources for both AWS Caller Identity and AWS Region. Then, we will output the
returned identity fo the caller and the current AWS region. It's a valuable practice to enhance our Terraform skills and
familiarity with these particular aspects.

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

- AWS Caller Identity Data Source: This data source should be defined to return the identity of the caller.
- AWS Region Data Source: This data source should be defined to get the current AWS region.
- AWS Caller Identity Output: This output should return the identity of the caller.
- AWS Region Output: This output should return the current AWS region.

--- 

## Step-by-Step Guide

- First, define the data source for the AWS Caller Identity. This data source is used to return the identity of the
  caller. This is achieved with the following code:

```hcl
data "aws_caller_identity" "current" {}
```

- Next, define the data source for the AWS Region. This data source is used to get the current region. This is done with
  the following code:

```hcl
data "aws_region" "current" {}
```

- Then, output the AWS Caller Identity. This will return the identity of the caller. This is done with the following
  code:

```hcl
output "aws_caller_identity" {
  value = data.aws_caller_identity.current
}
```

- Finally, output the AWS Region. This will return the current region. This is done with the following code:

```hcl
output "aws_region" {
  value = data.aws_region.current
}
```

---

## Question: More about data sources' `current`

The keyword `current` is often used in Terraform data sources to refer to the currently active configuration or
environment. It is not limited to regions and is used in other contexts as well. Below are examples of Terraform data
sources where current is used:

### `aws_caller_identity` (Current AWS Account Information)

This data source retrieves details about the currently authenticated AWS uses or role.

```hcl
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}
```

- **Use Case**:
    - Retrieve the AWS account ID dynamically for tagging or resource policies.
    - Get the ARN of the current user or role for debugging or reference.

### `aws_availability_zones` (Current Availability Zones)

This data source fetches a list of availability zones in the current region.

```hcl
data "aws_availability_zones" "current" {}

output "zones" {
  value = data.aws_availability_zones.current.names
}
```

- **Use Case**: Use the list of availability zones for creating subnets or balancing resources across zones.

### `aws_partition` (Current Partition)

Retrieves the partition (like aws for most regions, aws-cn for China, or aws-us-gov for GovCloud).

```hcl
data "aws_partition" "current" {}

output "partition" {
  value = data.aws_partition.current.partition
}
```

### `aws_region` (Current Region)

Retrieve the active AWS region.

```hcl
data "aws_region" "current" {}

output "current_region" {
  value = data.aws_region.current.name
}
```

- **Use Case**: Dynamically adapt configurations based on the deployment region.

### `aws_vpc` (Current VPC Search by Filters)

While not inherently current, we can combine it with other filters to dynamically fetch a specific VPC based on existing
criteria.

```hcl
data "aws_vpc" "current_vpc" {
  tags = {
    Name = "current-vpc"
  }
}
```

- **Use Case**: Dynamically fetch the current VPC configuration for resource association.

### `aws_caller_identity` with `iam_user` or role Context

Similar to `aws_caller_identity` example, the current context is frequently used with identity-based data sources to
dynamically fetch the context fo the context of running Terraform.

```hcl 
data "aws_iam_user" "current" {
  user_name = data.aws_caller_identity.current.user_id
}
```

* **Use Case**: Automating permissions or role management for the current authenticated user. 


