# Notes for Terraform _locals_

- **Definition**: Terraform's **locals** block is used to define local variables that are only accessible within the
  current Terraform module. They allow you to compute and reuse values without repeating logic.
- **Syntax**:
    ```hcl
     locals {
       variable_name = <expression> 
     } 
    ```
- **Use Cases**:
    - Simplify Repeated Expressions: Avoid repeating complex calculations or expressions.
    - Dynamic Computations: Create values based on inputs or other logic.
    - Centralized Reusability: Store commonly used values for consistency across resources.
- **Scope**:
    - Locals are scoped to the module where they are defined.
    - They cannot be directly accessed by child or parent modules.
- **Evaluation**:
    - Locals are evaluated **only once** during the **Terraform plan phase**.
    - Changes in variables or expressions used in locals will cause the plan to recompute the values.
- **Examples**:
    - **Concatenation Example**:
      ```hcl
      locals {
        environment_name = "${var.project_name}-${var.env}"
      }
      
      resource "aws_s3_bucket" "example" {
        bucket = local.environment_name 
      } 
      ```
    - **Conditional Logic**
       ```hcl
        locals {
          is_production = var.env == "prod" ? true : false 
        }
      
        resource "aws_instance" "example" {
          instance_type = local.is_production ? "m5.large" : "t2.micro"
        } 
       ```

    - **Reusable Tags**:
      ```hcl
        locals {
          common_tags = {
            Environment = var.env 
            Project = var.project_name  
          } 
        }
   
        resource "aws_s3_bucket" "example" {
          tags = local.common_tags 
        }
      ```

--- 

## Key Characteristics

- **Immutable**: Once defined, their values cannot change dynamically during a Terraform run.
- **Not Exported**: Cannot be accessed outside the module.
- **Pure Functions**: Expression in locals should not depend on resources whose attributes are determined during
  runtime.

--- 

## Best Practices:

- Use meaningful names for locals to describe their purpose.

- Avoid overusing locals to prevent confusion with variables.
- Use locals sparingly for computed values that enhance readability and maintainability.

--- 

## Comparison with Variables

### Variables

- Purpose: Define configurable inputs
- Scope: Accessible via inputs
- Mutability: User-configurable
- Evaluation: During runtime

### Locals

- Purpose: Define reusable computed values
- Scope: Limited to the defining module
- Mutability: Immutable once defined 
- Evaluation: During plan phase 

--- 

## Questions

### Where are `locals` stored ?

- `locals` are not persisted in the backend state file or local files.
- They are **computed at runtime** during Terraform's execution (e.g., plan or apply) and exist only temporarily in the
  memory during the execution process.

### Comparison with variables

- Variables (defined in `variables.tf` or `.tfvars` files) are inputs that can affect the state of the infrastructure
  and may indirectly influence the state file through resource definitions.
- `locals`, on the other hand, are derived values used purely within the Terraform configuration and **do not appear**
  in the state file or persist beyond the runtime.
- Variables themselves are not stored in the state file, however, the values assigned to resources through variables are
  **written to the state file(as part of the resource's configuration state)**. **Locals** only exists in runtime phase
  memory.

### How to Print the Value of locals

### Use `output`:

Add an output block to Terraform `.tf` to display the value of a local variable after `terraform apply`.

```hcl
locals {
  environment_name = "${var.project_name}-${var.env}"
}

output "environment_name_output" {
  value = local.environment_name
}
```

### Use Terraform Console

- The `terraform console` command allows us to evaluate and view local variable values directly.

```shell 
terraform console 
> local.environment_name 
"xxx"
```