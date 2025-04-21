# Terraform `import` and Its Lifecycle

## What is `terraform import` ?

`terraform import` brings **existing infrastructure**(provisioned outside of Terraform ) under Terraform's management by
adding it to the state file.

- What `terraform import` Does ?
    - It maps an external resource to a resource block in our Terraform configuration.
    - It does **not modify the actual infrastructure**
    - The imported resource is added to the **state file**, but it does not automatically update our Terraform
      configuration(.tf files).

--- 

## Why Use `terraform import` ?

- To manage pre-existing resources created outside Terraform.
- To avoid resource duplication or conflicts when applying Terraform configurations.
- To synchronize Terraform's state with your existing infrastructure.

--- 

## Understanding the Difference Between data Source and terraform import.

### Key Difference Between data source and terraform import

| **Feature**                | **Data Source**                                                              | **Terraform Import**                                                                     |
|----------------------------|------------------------------------------------------------------------------|------------------------------------------------------------------------------------------|
| **Purpose**                | Used only to query existing resources, without managing their lifecycle.     | Imports an existing resource into Terraform’s management (state file).                   |
| **State File**             | Writes queried values to the state file, but only as data references.        | Fully writes the resource’s state into the state file and makes it managed by Terraform. |
| **Configuration Required** | Requires a `data` block with filters to query the resource.                  | Requires a corresponding `resource` block; otherwise, `plan` or `apply` will fail.       |
| **Resource Lifecycle**     | Managed externally (e.g., AWS Console) and unaffected by Terraform.          | Fully controlled by Terraform, including lifecycle management.                           |
| **Destroy Capability**     | Cannot destroy the resource because Terraform does not manage its lifecycle. | Can be destroyed using Terraform (e.g., via `terraform destroy`).                        |

### Behavior of data Source

- The data source is **read-only** and is used to query attributes of an existing resource (e.g., AMI ID, VPC ID).
- While the query result is saved in the state file, the resource itself is **not managed by Terraform**.
- Terraform commands like `apply` or `destroy` have no effect on resources referenced by `data sources`.

### Behavior of terraform import

- Adds a Resource to the State File: The `terraform import` commands imports the state of an existing resource into
  Terraform's state file.
- Requires Configuration Synchronization(Manually):
  - After importing a resource, ensure that the Terraform configuration file (.tf) includes a matching resource block(
    here, it depends on different situations, let's talk about it later in next section.).
  - If the resource block and the state file are out of sync, running `terraform plan` or `terraform apply` will result
    in discrepancies and potential unintended changes.
  - **Become Fully Managed by Terraform**: Once imported, the result is **completely managed by current Terraform
    Project**,
    including its **lifecycle(init, create, destroy)**.
  -

### Importing Resources and Updating Configuration

When using `terraform import`, the workflow should be:

- **Import the Resource**:
-

--- 

## `terraform import` Classic Cases Introduction

### Case1: Result already exists in the configuration (but not managed by Terraform)

- **Scenario**: The resource declaration is already present in the .tf file, but it needs to be linked to an existing
  resource in the cloud.
- **Steps**:
  - Import the resource: This updates the Terraform state file to include the existing resource from the cloud
    infrastructure.
  -
  ```shell
  terraform import <RESOURCE_TYPE>.<NAME> <RESOURCE_IDENTIFIER>
  ```
  - After `import`, ensure that the resource in the .tf file matches the imported resource in terms of arguments and
    attributes.
  - Run `terraform plan` to verify consistency.
  - If necessary, apply the configuration to make changes or bring the resource into compliance.

- **KeyNote**: In this case, the .tf configuration **already exists**, and the import command ensures the resource is
  managed by Terraform without destroying or recreating it.

### Case2: Adding a new type of resource not declared in the configuration

- **Scenario**: You want to manage an existing resource in the cloud, but there is not corresponding block in the .tf
  file.
- **Steps**:
  - **Write the resource block** in the .tf file, ensuring it matches the actual configuration of the existing resource.
  - **Import the resource** to associate with Terraform's state file.
  ```shell
  terraform import <RESOURCE_TYPE>.<NAME> <RESOURCE_IDENTIFIER>
  ```
  - Run `terraform plan` to validate that the state and the configuration align.
  - Make necessary changes in the `.tf` file, if needed, and then apply.
- **KeyNote**: In this case, the .tf configuration **must be written first**, because Terraform needs to know how to map
  the imported resource to its state.

### Case3: Replacing an Existing Resource in the Cloud Architecture

- **Initial Scenario**:
  - A resource is already defined in the .tf file and this resource is already managed by Terraform.
  - However, the actual resource in the cloud (target resource) is different from the one current managed by Terraform.
- **Goal**:
  - Replace the current resource in Terraform's state file with the target resource in the cloud, ensuring Terraform
    starts managing the target resource instead.
- **Steps**:
  - Update the .tf file:
    - Modify the resource block in the .tf file to match the configuration of the target resource.
    - Ensure the name, type, and attributes correspond to the target resource.
  - Run `terraform import`:
    - Use the `terraform import` command to replace the resource in the state file with the target resource from the
      cloud.
    - ```shell
       terraform import aws_security_group.target_sg sg-0abcd1234efgh5678
       # sg-0abcd1234efgh5678 is the target resource already deployed and running on the cloud side
       # target_sg is the resource name declared in the .tf file with resource type of aws_security_group
      ```
  - **Verify Configuration** with command `terraform plan`:
    - Check for discrepancies between the updated .tf file and the imported resources.(whether their types are match,
      whether the resource is active and can be fetched from current region such kind of things)
    - Make any necessary adjustments in the .tf file.
  - **Run** `terraform apply`:
    - Apply the changes to ensure the state file, .tf configuration, and cloud infrastructure are fully synchronized.

### Case4: Moving Resources Between Modules

- **Scenario**:
  - A resource was originally declared outside a module but needs to be moved into a module for better organization for
    modularization.
  - For example, moving an `aws_instance` resource from the root module to a nested module.
- **Steps**:
  - Write the resource configuration in the module with the same attributes and settings as the original resource.
  - Run `terraform import` to import the resource into the module's namespace using the use address, e.g.,
    `module.<module_name>.aws_instace.example`.
  - Run `terraform plan` to verify no unintended changes.
  - Apply the changes to update Terraform's state and confirm the resource is managed within the module.

### Case5: Partial Import for Modular Resources

- **Scenario**:
  - You're importing a resource that is part of a larger system but only need to manage specific attributes or
    components in Terraform.
    - For example, importing an `aws_s3_bucket` resource without importing its associated bucket policy.
- **Steps**:
  - Write the configuration for the specific resource (e.g., S3 bucket) you want to manage in the .tf file.
  - Import only that resource into the Terraform state, ignoring associated resources for now.
  - Apply changes to ensure the configuration is in sync with the state.
  - Gradually add the remaining resources (e.g., bucket policy) if needed, using additional imports and configuration
    blocks.

### Case6: Handling State Drift

- **Scenario**:
  - The actual state of a resource in the cloud has drifted from Terraform's state, causing `terraform plan` to show
    unintended changes.
  - For example, someone manually updates an EC2 instance's security group in the AWS Console.
- **Steps**:
  - Use `terraform import` to re-sync the resource's actual state with Terraform's state file.
  - Review the drift using `terraform plan`.
  - Update the .tf file to align with the current configuration, or override the drift by reapplying the desired
    configuration.
  - Apply changes to finalize the alignment.

### Case7: Splitting / Combining State Files

- **Scenario**:
  - Large Terraform projects may benefit from splitting state files by resource type or environment (e.g., separating
    production and staging).
  - Conversely, multiple state files might need to be combined for central management.

- **Steps for Splitting**:
  - **Identify Resource to Split**:
    - Decide which resources will be moved to a new state/project.
    - Ensure you understand all the dependencies and associations of these resources.
  - **Prepare the New Configuration**:
    - Before removing the resource from the current state file, prepare a new .tf file (e.g., split-small.tf) with the
      resource declarations.
    - Ensure the new configuration matches the resource's current state.
  - **Remove from the Current State**:
    - Use `terraform state rm` to remove the resource from the original project's state file:
      ```shell
      terraform state rm <resource_address>
      ```
      At this point, the resource becomes **unmanaged** temporarily.
  - **Import into the New State**
    - In the new project or .tf file, import the resource into the new state.
    ```shell
    terraform import <resource_address> <actual_resource_id>
    ```
  - **Clean Up the Original Configuration**:
    - Remove references to the split resource in the original .tf file (e.g., large.tf).
    - Update any associated resources or outputs that referenced the split resource to point to the new configuration (
      if applicable).
  - **Verify Dependencies**:
    - Ensure that any child or dependent resources have been correctly moved to the new configuration or updated to
      reference the new location.Ω
  - **Run Terraform Plan and Apply**:
    - In both the original and new projects, run `terraform plan` and `terraform apply` to ensure everything is properly
      synchronized and no unintended changes are made.
- **Steps for Combining**:
  - Add all resource configuration into a single .tf file.
  - Use `terraform import` to import resources from different state files into the combined state.
  - Apply changes to consolidate management.

### Case8: Ignoring Changes to Specific Attributes

- **Scenario**:
  - Some attributes of a resource are managed externally (e.g., through an auto-scaling tool) and should be ignored by
    Terraform.
  - For example, the `desired_capacity` of an `aws_autoscaling_group` is updated outside of Terraform.

- **Steps**:
  - Use `lifecycle {ignore_changes = ["<attribute_name>"]}` in the resource configuration block to exclude the attribute
    from Terraform's management.
  - Import the resource using `terraform import` to sync the state file.
  - Ensure the .tf configuration includes `ignore_changes` for the desired attributes before applying changes.

### Case9: Handling Sensitive Data with terraform import 

- **Scenario**:
  - Sensitive data (e.g., access key, secrets) is part of resource that needs to be imported, but you don't want to
    expose it in the .tfstate file.
- **Steps**:
  - Write the resource block in the .tf file without sensitive attributes.
  - Import the resource using `terraform import`
  - Add sensitive attributes as environment variables or via secret management tools(e.g., AWS Secrets Manager.)
  - Avoid hardcoding sensitive values in Terraform configurations or state files.
  - Apply the configuration to ensure sensitive data is properly managed without being stored in plaintext.

--- 

## Question: `terraform import` Move resource From Project/Module A to Project/Module B :

Suppose I import resource X from Terraform Project/Module A to Project/Module B and update Module B's .tf file to
include the resources:

* What happens to Module A's state file after the import ?
* Does Module A's .tf file need to be manually updated after apply Project/Module B? 

### Importing Resource X to Module B

- **Action**: Run `terraform import` in **Module B** to import resource **X** into its state file. This assumes **Module
  B's** .tf file is already updated to include a configuration for X.
- **Effect on Module B**:
  - Module B's **state file** is updated to include the resource X.
  - Module B now "manages" resource X as part of its lifecycle.
- **Effect on Module A**:
  - **State file**: The resource **X** is **not automatically removed** form **Module A's** state file. This creates a *
    *state drift** issue, where both modules might appear to manage the same resource unless resolved.
  - **.tf file**: No changes occur automatically to **Module A's** .tf file. The resource configuration for X will still
    exist unless manually removed.

### Running `terraform apply` in Module B

- **Action**: Run `terraform apply` in Module B to ensure that the resource X is fully managed by Module B and any
  configuration changes are applied.

- **Effect on Module B**:
  - Any changes defined in Module B's .tf file for X are applied to the resource in the cloud.
  - Module B's state file is updated to reflect the final state of resource X.
- **Effect on Module A**:
  - State file: Resource X remains in Module A's state file unless you explicitly remove it using `terraform state rm `.
  - .tf file: The configuration for X in Module A's .tf file remain untouched. We must **manually remove the resource
    configuration** for X from Module A to avoid conflicts.

### Final Steps to Resolve Conflicts

- **Remove Resource X from Module A's State File**:
  - Use `terraform state rm ` in Module A to remove resource X from its state file:
- **Manually Update Module A's .tf File***:
  - Remove the resource block for X from Module A's .tf file to reflect that the resource is no longer managed by Module
    A. 