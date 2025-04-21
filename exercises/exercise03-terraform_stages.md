# Understanding the Different Terraform Stages

## Introduction

In this exercise, we aim to learn about the different stage of Terraform. We'll go through the process of initializing
our working directly,
planning and applying our configuration, and finally, destroy the infrastructure when it's no longer needed. This
hands-on experience will provide an understanding of the practical benefits and the lifecycle of IaC.
--- 

## Step-by-Step Guide

Make sure you are in the `01-benefits-iac` directory and run the following commands, always taking a break to analyze
and understand the output of the commands.

* Use the `terraform init` command to initialize your working directory. This command prepares your directory for other
  Terraform commands and ensures that Terraform has everything it needs to run.
* Use `terraform plan` to create an execution plan. This command determines what actions are necessary to achieve the
  desired state specified in your configuration files.
* Once you're satisfied with the plan, apply it using `terraform apply`. This command will make the necessary changes to
  reach the desired state of your configuration files.
* When you no longer need the infrastructure, you can use `terraform destroy` command to remove all resources created by
  your Terraform configuration. This will also clean up the state.

--- 

## Terraform Files Introduction

When we execute the Terraform series of commands, there are series of files generated during the process.

### `.terraform(Directory)`
* This directory contains the downloaded providers and state-related metadata. 
* Deleting this directory will require Terraform to re-download providers during the next terraform init.

### `.terraform.lock.hcl`
* This file locks the provider versions to ensure consistent deployments across different environments or team members. 
* You do not need to delete this file unless you want to update the provider versions. 

### `.terraform.tfstate.lock.info`

* This is a temporary lock file created when Terraform acquires a state lock. It should be automatically deleted after a successful operation. If it remains, it likely indicates a previous operation was interrupted. 
* We can delete it if no other Terraform process is using it. 

### `terraform.tfstate`

* This is the main state file that tracks the infrastructure deployed by Terraform.
* Deleting this file means Terraform will no longer have knowledge of the existing infrastructure, and subsequent
  commands may recreate resources.
* **Only delete this file if you want to start refresh** or if the state is no longer valid. 
