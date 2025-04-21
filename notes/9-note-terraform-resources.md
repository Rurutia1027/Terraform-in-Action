# Notes for Terraform _Resources_

## Resources are used to configure real-world infrastructure objects

* They are used to manage any infrastructure that we want to manage with Terraform, and are the most important blocks
  within Terraform.
* Resource blocks represent things like virtual networks, compute instances, DNS records, storage disks, among others.
* The arguments depend on and vary based on the resource type.
* The combination of resource type and resource name must be unique within a module. This is how Terraform links the
  resource to its respective real-world object.
* If no other provider is specified, Terraform will use the default provider to provision the infrastructure. We can use
  the `provider` meta-argument to explicitly pass as different provider.
* Terraform offers a few local-only resources, such as generating random strings or IDs, private keys, or self-issued
  TLS certificates. 
* We can create multiple instances of resources by using Terraform loop (`for_each`, `count`). 