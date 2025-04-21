# Terraform Block

Here is an example of Terraform Block

```hcl
terraform {
  required_version = "1.7.0"

  backend "s3" {
    // ... 
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
  }
}
```

Terraform block is used for configuring the Terraform project (backend, providers, required versions), and here are some
tips for using Terraform Blocker. 

* Only constants are allowed within the `terraform` block. Input variables or resource references are not allowed. 
* `cloud` block: used to configure Terraform Cloud. 
* `backend` block: used to configure a state backend for the project.  
* `required_version` key: used to specify the accepted versions of Terraform for the current project.
* `required_providers` block: specifies the required providers for the current project or module, including their accepted versions.

- **Version Constrains**
  * `=`: this constrain allows only the specified version. 
  * `!=`: this constrain excludes an exact version.  
  * `>=, <=, >, <`: those constrains allow versions for which the comparison is true.  
  * `~>`: this constrain allows only the rightmost digit to increment. 