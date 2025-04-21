# Terraform Notes: References vs Data Sources

## Overview

In Terraform, **Reference** and **Data Sources** serve different purposes when working with resources, especially when
interacting with existing infrastructure. Understanding the distinction between them is crucial for managing state and
external data effectively.

--- 

## Key Points

### References

* **Definitions**: A Reference refers to any resource that is directly managed within the Terraform project.
* **Ownership**: These resources are **created**, **updated**, and **destroyed** by the Terraform configuration, meaning
  they are under Terraform's control.
* **Use Case**: **Reference** is used when you need to link resources within your Terraform configuraiton.

    ```hcl
    resource "aws_instance" "example" {
      ami           = "ami-123456789op"
      instance_type = "t2.micro"
    }
    
    output "instance_id" {
      value = aws_instance.example.id
    }
    ```

In the example above, `aws_instance.example.id` is a **Reference** that refers to the `aws_instance` resource created in
the configuration.

### Data Sources

* Definition: A **Data Source** allows you to **query information** about resources that are not **managed by the
  current Terraform configuration**.
* **Read-only**: Data source are **ready-only**, meaning Terraform can only **retrieve** information and cannot modify
  the external resources.
* **Use Case**: Data sources are used to gather information about existing infrastructure, which may have been created
  outside Terraform or in a different project.  
    ```hcl
    data "aws_ami" "latest" {
      most_recent = true 
      owners = ["amazon"]
      filters = {
          name = "amzn2-ami-hvm-*-x86_64-gp2"
      }
    }
  
    resource "aws_instance" "example" {
        ami = data.aws_ami.latest.id 
        instance_type = "t2.micro"
    }
    ```
  In this example, `data.aws_ami.latest.id` is a **Data Source** that queries for the latest Amazon Linux 2 AMI without modifying it. 