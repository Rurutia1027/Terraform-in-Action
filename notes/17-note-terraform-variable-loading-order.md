# Notes for Terraform _Variable Files_ Default Loading Rules

## If Do Not Use `-var` or `-var-file`

Terraform automatically loads variables files in the following order(from lowest to highest priority):

### Default Values in `variable` Blocks

_actually it is not the `variable.tf` file it is `variable` block declared in all
`.tf` files_

* Variables declared in `variables.tf` with a default value will be loaded first.
* If not default value is provided, Terraform will prompt you to supply the value(via CLI).

### `terraform.tfvars` File

* If the `terraform.tfvars` file exists, Terraform will load it and override any previously loaded default values.

### `*.auto.tfvars` File(s)

* Terraform automatically loads any `*.auto.tfvars` files in the current directory (e.g., `dev.auto.tfvars`,
  `prod.auto.tfvars`) and further overrides previously loaded values.
* If multiple `*.auto.tfvars` files exist, they are loaded in alphabetical order.

### `override.tfvars` File

* If the `override.tfvars` file exists, Terraform loads it last, and it takes the highest priority among all
  automatically loaded files.

---

## If Use `-var` or `-var-file`

- `-var`:
    - Specify individual variable values via the command line:
  ```shell
  terraform apply -var="aws_region=us-west-1"
  ```
    - This value takes the highest priority and overrides all other sources
- `-var-file`:
    - Explicitly specify a variable file:
  ```shell
   terraform apply -var-file="ttxxtt.tf"
  ```
    - When using `-var-file`, Terraform **only loads the specified file** and ignores automatically loaded files such as
      `terraform.tfvars` `*.auto.tfvars`, and `override.tfvars`.

--- 

## Key Points to Note

- if we do not specify `-var` or `-var-file`
    - Terraform will load files in the order of `terraform.tfvars` -> `*.auto.tfvars` -> `override.tfvars`.
    - If none of these files exist, Terraform will use the default values defined in `variables.tf`.
- If we use `-var-file`
    - Terraform **only loads the specified file** and the file name does not need to follow any specific naming
      convention (e.g., it doesn't have to be variables.tf).
    - Once `-var-file` is invoked, then all other variable files like `*.auto.tfvars`, `terraform.tfvars`,
      `override.tfvars` and `variables.tf` all will not be loaded by the Terraform.
- If we use `-var` to specify a single variable:
    - The variable defined in `-var` takes precedence and override all other sources.
    - Other `*.tfvars` files will be loaded in order as normal, and this is different from `-var-file` exclude all other
      not specified variable files loading rule.
- If we use both `-var` and `-var-file`
    - All variables in the `-var-file` assigned variable files will be loaded first, and the same, all remain `*.tfvars`
      files will be excluded.
    - Then, variables specified via the `-var` will override the same variables that declared in the `-var-file`
      assigned files if there are duplicated variables declarations.

--- 

## Question: Corner Cases Question:

Are those `-var-file=terraform.tfvars` or `-var-file=a.auto.tfvars` commands illegal ?

Both `-var-file=terraform.tfvars` and `-var-file=a.auto.tfvars` commands are legal, because Terraform's `-var-file`
with **any valid file name ` that contains variable definitions in HCL or JSON.

--- 

## `variables.tf` files or other variable block files

The `variables.tf` file serves two purposes: defining variables and setting constrains (like types, validation), and is
always loaded during Terraform operations. Its role is foundational for variable creation. The loading order we talked
about above is mainly concerns how values are assigned to these predefined variables, with priority determined by the
order of files (e.g., -var, terraform.tfvars, override.tfvars those files only declare default values no variables
creation and constrains are declared in `.tfvars` files!). The `variable.tf` file's or other `.tf` files that contain
the `variable block` contains the variables' constrains are essential and apply regardless of priority. The loading
order impacts the assignment of values to these variables after initialization, while the constrain rules ensure valid
configurations. 


--- 

## `TF_VAR`'s Precedence

- `-var` && `-var-file` > `TF_VAR_ec2_instance_type=xx` > all `.tfvars` and `*.auto.tfvars` and `.tf` variable block
default values


