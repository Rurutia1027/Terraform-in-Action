# Notes for Terraform _Input Variables_

**Customize values based on variables to create reusable and composable code**

## Motivations for input variables

- To be able to customize aspects of Terraform configurations and modules without having to alter the source code.

## Notes around variables:

- It's convention to declare them inside of `variables.tf` file, and we use them via `var.<NAME>`.
- When defining a variable, we can se the type provide a description, give a default value, set `sensitive` to a boolean
  value, and provide validation rules.
- When we run `terraform plan` or `terraform apply` and don't provide command-line argument for the variables, it will
  ask us to provide the values for each of the variables.
    - If we provide defaults, Terraform will not ask for these values.

--- 

## Terraform Variable's Precedences

### Default Values in Configuration Files
- **Location**: Defined within the variables block in .tf files. 
- **Example**: 
  ```hcl
  variables "region" {
    default = "us-east-1"  
  }
  ```
### Environment Variables
- **Location**: Set in the shell environment using the prefix `TF_VAR_`.
- **Example**: 
    ```hcl
    export TF_VAR_region="us-west-2" 
    ```
- **Precedence**: Overrides default values

### Terraform `.tfvars `or `.tfvars.json` Files

- **Location**: Automatically loaded if named `terraform.tfvars` or `terraform.tfvars.json`, and this can also specify
  custom files using the `-var-file` flag.
- **Example(terraform.tfvars)**:
  ```hcl
  region = "eu-central-1"
  ```
### Command-Line `-var` Flags

- **Location**: Passed directly during `terraform plan` or `terraform apply`.
- **Example**:
    ```hcl 
     terraform apply -var="region=ap-southeast-1"
    ```

### Input from Terraform Cloud/Enterprise

- **Location**: Defined in Terraform Cloud/Enterprise workspace.
- **Usage**: Terraform uses these values when running in the Cloud/Enterprise environment.
- **Precedence**: Takes priority over CLI flags, `.tfvars` files, environment variables, and defaults.

### Module-Specific Values

- **Location**: Passed as arguments when calling modules.
- Example:

```hcl
 module "my_module" {
  source = "./my_module"
  region = "ca-central-1"
}
```

- **Precedence**: Overrides all other values when passed explicitly to a module.