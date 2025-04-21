# Notes for Terraform _Dependencies_

## Terraform supports both parallel and sequential creation of resources.

* Certain resources can be created in parallel, while other resources depend on each other and must be created in a
  certain order.
* Terraform supports both parallel and sequential management of resources.
* Terraform inspects the expressions to automatically establish implicit dependencies between resources.
* Additionally, we can define explicitly dependencies via the `depends_on` meta-argument.
* If the operation on an upstream resource fails, Terraform will not continue the operations on downstream resources.
* We can also force Terraform to replace a parent resource in case a child resource is modified by using the
  `replace_triggerd_by` meta-argument. 