# Using a Remote S3 Backend

## Introduction

In this exercise, we will guide you through the steps for setting up an S3 backend for Terraform. This allows you store
your Terraform state in an S3 bucket, providing a secure, remote storage solution. Understanding how to set up and use
an S3 backend is crucial for managing and collaborating on Terraform projects. Let's get start!.

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and solution videos, here is an overview of
what the created solution should deploy:

* A manually created S3 bucket used to store the state file, uniquely named and in the region of your choice.
* S3 backend configured in the Terraform configuration file by referencing the created S3 bucket and providing a
  relevant key to store the state file.
* Terraform successfully initialized with the S3 backend.
* Terraform configuration successfully applied and state stored in the S3 bucket.

--- 

## Step-by-Step Guide

* First, make sure you have Terraform version 1.7 or later installed. You can check this by running `terraform version`
  in your terminal.
* Copy the files from the folder `03-first-tf-project` to a new folder named `04-backends`.
* You will also need to have the AWS and Random providers installed. These can be installed by running the command
  `terraform init` inside the folder `04-backends`.
* Next, you will need to set up your S3 bucket. Choose a unique name for it, and make sure the bucket is created in the
  region of your choice. You ca set this up through the AWS console or using the AWS CLI.
* Now, you can configure the S3 backend in your Terraform configuration. This is done in the `backend s3` block in your
  configuration file. Replace the `<your-aws-region>` with the respective region you are using for the course.

```hcl
backend "s3" {
  bucket = "<your-bucket-name>"
  key    = "04-backends/state.tfstate"
  region = "<your-aws-region>"
}
```

* Configure the AWS provider by using the `provider "aws"` block, and make sure it uses the correct region for your
  projects.
* Finally, run `terraform init` again. This will initialize your backend. You should see a message that Terraform has
  been successfully initialized and the "s3" has been configured.
* Now, you can run `terraform apply` to apply your configuration. Terraform will store the state in the S3 bucket you
  configured.
* Make sure to destroy the resources after you complete all the steps.

--- 