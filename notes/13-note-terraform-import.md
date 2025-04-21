# Notes for Terraform __imports__

`terraform import` is used to bring existing resources into Terraform's management. It does not create or destroy
resources; instead, it updates Terraform's state file with the resource information.

## Key Concepts

- Import updates only the state file; it does not generate configuration files automatically.
- After importing, you must manually write the resource configuration in your Terraform files. Without this, subsequent
  `terraform plan` runs may show discrepancies.

## Use Cases

- **Managing existing resources**: Import manually created resources or existing infrastructure into Terraform. 
- **Migration**: Transitioning from another tool to Terraform for managing resources. 
- **Diagnostics**: Checking and verifying the state or parameters of existing resources. 

```shell
# syntax: terraform import [options] ADDRESS ID 
terraform import aws_instance.my_instace i-1238943ijsjdkfl
```

* **ADDRESS**: The resource path in your Terraform configuration. 
* **ID**: The unique identifier assigned to the resource by the cloud provider (e.g., instance ID or ARN)