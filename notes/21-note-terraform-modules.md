# Notes for Terraform _Modules_

**Organize, encapsulate, and re-use Terraform components**

- Modules are used to combine different resources that are normally used together. They are just a collection of `.tf`
  files kept in the same directory.
    - **Root module**: the set of files in the main working directory.
    - Root modules can then call other modules(child modules), defined either locally or remotely.
- The goal is to develop modules can be reused in various ways.

--- 

## Why Use Modules?

### Organize Configuration

Modules allow us group related parts of the infrastructure to make the code easier to understand and improve
maintainability.

### Encapsulate Configuration

Modules also enable encapsulate sets of resources to prevent unintended changes and mistakes that can happen in complex
bases.

### Re-use Configuration

Modules make it much easier to reuse entire sets of components, thus improving consistency, saving time, and preventing
errors.

### Ensure Best Practices

Modules provide configuration and infrastructure best practices, and publish modules both publicly and privately for use
by other teams.


--- 

## Standard Module Structure

- LICENSE
- main.tf
  `main.tf` is the main entry point for module resources(like Rust's mod). More complex modules should split the
  resources into multiple files with relevant names. Other file name is ok.

- outputs.tf
  `outputs.tf` contains all outputs from the module. Used by Terraform Registry to generate documentation.

- README.md
- variables.tf
  `variables.tf` contains all variables for the module. Use by Terraform Registry to generate documentation.
