# Notes for Terraform _Registry_ and _Module_

## Registry && Module

In Terraform, the **Registry** and **Module** relationship works as follows:

- **Registry**: A centralized platform (e.g., Terraform Registry) where reusable Terraform modules are published,
  shared, and versioned.
- **Module**: A reusable block of Terraform configuration code designed to manage a specific resource or set of
  resources(e.g., VPC, EC2).

--- 

## Registry && Module Relationship

- The **registry** hosts **modules** that can be directly consumed in your Terraform configuration by referencing their
  source (registry URL, name, and version).

--- 

## Use Module What We Need to Do?

- **Declare the Provider**
    - Most modules are specific to a cloud provider(e.g., AWS, Azure, GCp). We must declare the provider in our
      Terraform configuration.
- **Reference the Module**
    - Use the module block to call a module from the registry by specifying its source and version.

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  # other required variables 
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}
```

- **Provide Required Variables**
    - Modules often require input variables. Check the module documentation for required and optional variables, when
      provide them in our module block or terraform.tfvars.
- **Review Outputs**
    - Modules can also define outputs. After running Terraform, we can use `terraform output` to see the value or
      reference them elsewhere in our code.

--- 

## Module Types

### Public Module

* Hosted in the Terraform Registry
* Referenced using its source as

```
<NAMESPACE>/<MODULE_NAME>/<PROVIDER>
```

```hcl
source = "terraform-aws-modules/vpc/aws"
```

### Private Module

* Hosted in a private Terraform registry or version control (e.g., GitHub, GitLab)
* Referenced with a repository URL:

```hcl
source = "git::https://github.com/example-org/terraform-vpc-module.git?ref=v1.2.0"
```

### Local Module

* Stored locally on your filesystem
* Referenced using a relative or absolute pth

```hcl
source = "./modules/my-vpc"
```

--- 

## Declaring a Module Versions: Public vs. Private Modules

### Public Modules

* Use version to specify the module version directly from the Terraform Registry:

```hcl
module "example" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
}
```

### Private Modules

* Use a Git branch, tag, or commit hash for versioning

```hcl
module "example" {
  source = "git::https://github.com/example-org/vpc-module.git?ref=v1.0.0"
}
```

### Local Modules

* No versioning is possible; updates must be managed manually.