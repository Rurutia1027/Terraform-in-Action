# Partial Backend Configuration

## Introduction

In this exercise, we will walk you through the process of setting up a partial backend configuration for Terraform. The
tutorial will guide you to configure the S3 Backend for Terraform, create separate backend configuration files for
development and production environments, and specify which backend configuration file Terraform should use. After
completing this exercise, you will have a more in-depth understanding of how to manage different backend configurations
for various environments in Terraform.

--- 

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-step and the solution videos, here is an overview
of what the created solution should deploy:

* Successfully configure the S3 Backend for Terraform.
* Create a `dev.tfbackend` file to provide the partial backend configuration for the development environment.
* Create a `prod.tbbackend` file to provide the partial backend configuration for the production environment.
* Be able to specify which backend configuration file Terraform should use by passing it as a command line argument.

---

## Step-by-Step Guide

* Keep working on the files from the folder `04-backends`
* Replace the `backend "s3"` block in your Terraform configuration with the following:

```hcl
backend "s3" {
  bucket = "<your-bucket-name>"
  region = "<your-aws-region>"
}
```

Note that we've removed the specific backend key and will instead be using a key that includes the environment from a
`tfbackend` file.

* Create a file called `dev.tfbackend`. This file will provide the partial backend configuration for the development
  environment. In the `dev.tfbackend` file, add the following:
    ```hcl
    key = "04-backends/dev/state.tfstate"
    ```

  This sets the S3 key to a path under `04-backends/dev`.
* Create a file called `prod.tfbackend`. This file will provide the partial backend configuration for the production
  environment. In the `prod.tfbackend` file, add the following:
    ```hcl
     key = "04-backends/prod/state.tfstate"
    ```

This sets the S3 key to a path under `04-backends/prod`.

* Pass the backend file to Terraform. You can specify which backend configuration file Terraform should use by passing
  it as a command line argument. For example, to use the development backend, you would run the following command:
    ```shell 
    terraform init -backend-config=dev.tfbackend 
    ```
  Similarly, to use the production backend, you would run:
  ```shell
   terraform init -backend-config=prod.tfbackend 
  ```
  This will ensure that Terraform uses the correct state file depending on whether you're working in the development or
  production environment.

Go ahead and give it a try! With these steps, your S3 Backend is configured for Terraform and you can separate backend
configuration files for development and production that will store the state in different paths in the S3 bucket.

* Make sure to destroy the resources after you complete all the steps.

--- 

## Migrate & Reconfigure 
* Error Message Shown When Executing `terraform init -backend-config=dev.s3.tfbackend`:

```text 
Initializing the backend...
╷
│ Error: Backend configuration changed
│ 
│ A change in the backend configuration has been detected, which may require migrating existing state.
│ 
│ If you wish to attempt automatic migration of the state, use "terraform init -migrate-state".
│ If you wish to store the current configuration with no changes to the state, use "terraform init -reconfigure".

```
This error message indicates that Terraform detected changes in the backend configuration, such as a different S3 bucket, key, or region.
There are two options to solve this situation.

### Migrate the State (`-migrate-state`)
If we want to move the existing state file to the new backend (e.g., an updated S3 bucket or key), run this 
```shell 
terraform init -migrate-state 
```

- **What this does**
  - Transfers the state file from the old backend (if any) to the new one specified in your backend configuraiton. 
  - Ensures Terraform uses the updated backend moving forward. 

### Reconfigure Without Migration (`-reconfigure`)
If we do not need to migrate the state file (e.g., you're setting up a new environment or project), run this: 

```shell
terraform init -reconfigure 
```

- **What this does**
  - Updates the Terraform configuration without attempting to move any existing state file
  - Useful for starting fresh with a new backend configuration. 