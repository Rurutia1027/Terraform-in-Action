# Notes for Terraform _Publishing Modules_

**Publishing Modules make your Terraform module available to others via Terraform Registry**

* Anyone can publish a module, as long as the following conditions are met:
    * The module must be on GitHub and must be a public repo. This is required only for using the public registry; for
      private ones, this can be ignored.
    * Repositories must use a naming format: `terraform-<PROVIDER>-<NAME>`, where `PROVIDER` is the provider where
      resources are created, and `NAME` is the type of infrastructure managed by the module.
    * THe module repository must have a description, which is used to populate the short description of the module. This
      should be a simple one sentence description of the module.
    * The module should adhere to the standard module structure(`main.tf`, `outputs.tf`, `variables.tf`). The registry
      uses this information to inspect the module and generate documentation.
    * Uses `x.y.z` tags for releases. The registry uses these tags to identify module versions. Release tag names must
      be a semantic version, and can be optionally prefixed with a `v`.
* Published modules support versioning, automatically generate documentation, allow browsing version histories, show
  examples and README , and more.