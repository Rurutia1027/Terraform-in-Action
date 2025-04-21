# Notes for Terraform's _Sensitive Data_ Mechanisms

## Key Concepts:

### **Making Variables as Sensitive**:

- We can declare a variable as sensitive to prevent its value from being displayed in logs or command outputs.

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

    - Effect: The value is masked in `terraform plan` and `terraform apply` outputs.

### **Sensitive Attributes in Resources**:

- Some Terraform resources automatically mark sensitive attributes as sensitive, such as `aws_secretsmanager_secret`,
  ensuring secret handling.

```hcl
resource "aws_secretsmanager_secret" "example" {
  name  = "example"
  value = var.db_passwrod
}
```

### Avoid Hardcoding Secrets

- Best Practice: Never hardcode sensitive values in `.tf` files.
- Use external sources or files to inject secrets dynamically.

--- 

## Secure Secret Injection Methods

### Terraform Variables and `.tfvars` Files;

- Use .tfvars files to supply sensitive values, but **do not commit them to version control**.
- Add .tfvars files to .gitignore.

### Environment Variables

- Export sensitive values as environment variables, which Terraform can read using interpolation.

```shell
export TF_VAR_db_password="my-secret-password"
```

- After exporting sensitive data to local environment variables, refer the export variable by

```hcl
variable "db_password" {}
```

### Secrets Management Tools:

- Integrate with secrets management tools such as AWS Secrets Manager, HashiCorp Vault, or Azure Key Vault.

```hcl
data "vault_generic_secret" "example" {
  path = "secret/data/db"
}

variable "db_password" {
  default = data.vault_generic_secret.example.data["password"]
}
```

### Dynamic Secrets

- Use Service like AWS Secrets Manager or Vault to dynamically generate and fetch credentials at runtime.

--- 

## Protecting Sensitive Information

### State File Encryption

- **Terraform state files contain all the configuration data, including sensitive values.**
- Use a secure backend (e.g., S3 with encryption or HashiCorp Vault) to store the state file securely.
```hcl
# example use S3 as backend with encryption
backend "S3" {
  bucket     = "my-tf-state"
  key        = "terraform.tfstate"
  region     = "us-east-1"
  encrypt    = true
  kms_key_id = "alias/my-key"
}
```

### Remote State

- Use remote backends (e.g., Terraform Cloud, S3, GCS) to securely store data files away from local machines.

### State File Sanitization

- Terraform doesn't inherently redact sensitive values from the state file.
- To minimize risk:
    - Use `terraform state rm ` to remove sensitive resource after use.
    - Avoid storing secrets in resource attributes that are written to the state.

### Restrict Access

- Control access to the state file and secrets management integrations using IAM roles, policies, or ACLs.
  

