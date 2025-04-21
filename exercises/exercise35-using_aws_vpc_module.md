# Using the AWS VPC Module

## Introduction

In this exercise, we will be using the AWS VPC Module to setup a virtual private cloud (VPC) with specific subnet
configurations. This exercise is designed to help you become more familiar with Terraform modules and their application
in creating and managing AWS resources, particularly VPCs and subnets. By the end of this exercise, you will have a
deeper understanding of how to use data sources, how to use the AWS VPC module to create a VPC, and how to specify the
configuration for private and public subnets.


--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

- Use the public AWS VPC module to create a VPC named `12-public-modules` with a CIDR block of `10.0.0.0/16`.
- Fetch the available Availability Zones with a data source.
- Expand the VPC module to create a private subnet with a CIDR block of `10.0.0.0/24`.
- Extend the VPC module to create a public subnet with a CIDR block of `10.0.128.0/24`.

--- 

## Step-by-Step Guide

- Create a new folder `12-public-modules` and add a configuration block to the project's directory. Configure the AWS
  provider to the relevant region that you have been using.
  ```hcl
  terraform {
    required_version = "~> 1.7"
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }
  
  provider "aws" {
    region = "eu-west-1"
  }
  ```
- Use a data source to fetch the available availability zones for the specified region.

  ```hcl
  data "aws_availability_zones" "azs" {
    state = "available"
  }
  ```

- Let's. now use the public VPC module from AWS to create our VPC and subnets. Use version `5.5.3` to ensure
  compatibility. Let's use the following values for the VPC information:
    - VPC CIDR block: `10.0.0.0/16`
    - VPC name: `12-public-modules`
    - Private subnet CIDRs: `["10.0.0.0/24"]`
    - Public subnet CIDRs: `["10.0.128.0/24"]`

  ```hcl
  module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.5.3"
  
    cidr = "10.0.0.0/16"
    name = "12-public-modules"
    azs  = data.aws_availability_zones.azs.names
    private_subnets = ["10.0.0.0/24"]
    public_subnets = ["10.0.128.0/24"]
  }
  ```