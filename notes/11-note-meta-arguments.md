# Notes for: _Meta Arguments_

## Meta-arguments allow us to configure Terraform's behavior in many ways


### `depends_on`
- Used to explicitly define dependencies between resources.

### `count` and `for_each`
- Allows the creation of multiple resources of the same type without having to declare separate resource blocks.  

### `provider`
- Allows defining explicitly which provider to use with a specific resource. 

## `lifecycle`
- `create_before_destroy`
- `prevent_destroy`
- `replace_triggered_by`
- `ignore_changes`