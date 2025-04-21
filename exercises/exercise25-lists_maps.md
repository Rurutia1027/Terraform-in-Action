# Transforming Lists into Maps and Vice Versa

## Introduction

In this exercise, we will explore how to transform lists into maps and vice versa in Terraform. This knowledge will be
crucial in managing complex data structures and efficiently retrieving and manipulating data. The exercise is broken
down into detailed steps that walk you through the process of creating a `users` list variable, transforming this list
into a `users_map`, and then transforming that map back into a list. By the end of the exercise, you should have a good
understanding of how to work with lists and maps in Terraform.

## Desired Outcome

If you wish to give it a shot before looking into the detailed step-by-steep and the solution videos, here is an
overview of what the created solution should deploy:

- Create a `users` variable, which receives a list of objects, with each object containing a `username` and `role`
  properties.
- Create a `user_map` local, which transforms the `var.users` list into a map where the `username` property becomes the
  key in the map, and the `role` property becomes the value.
    - The `users_map` local should also handle duplicated usernames and returns a list of roles whenever a username
      appears more than once in the `users` variable.
- Create a `users_map2` local, which transforms our `local.users_map` into a new map with the following
  structure: `<key> => {roles = <roles list>}`.
- Create a `user_to_output` variable, which receives a string used to retrieve a specific user's information from our
  `users_map2` local.
- Create a `usernames_from_map` local, which transforms the `local.users_map` map into a list containing only the
  username of each map entry.
- Define outputs to visualize the information we have been processing so far.

---

## Step-by-Step Guide

- First, define a variable named `users`, which is of type list of objects, each object containing a `username` and
  `role` properties.

```hcl
variable "users" {
  type = list(object({
    username = string
    role     = string
  }))
}
```

- Now create a local `users_map`, which transforms the `var.users` list into a map where the `username` property becomes
  the key in the map, and the `role` property becomes the value. What happens when we have more than one entry in the
  list containing the same username?

```hcl
locals {
  users_map = {
    for user_info in var.users : user_info.username => user_info.role
  }
}
```

- Having a duplicated key will throw an error. Use the ellipsis operator at the end of `user_info.role` to group
  together all the roles in a single `username` under the same map key.

```hcl
locals {
  users_map = {
    for user_info in var.users : user_info.username => user_info.role...
  }
}
```

- Now create a new local which transforms our `local.users_map` into a new map with the following structure:
  `<key> => { roles = <roles list>}`

```hcl
locals {
  users_map2 = {
    for username, roles in local.users_map : username => {
      roles = roles
    }
  }
}
```

- Create a variable `user_to_output`, which is of typing string. This variable will be used to retrieve a specific
  user's information from our `users_map2` local.

```hcl
variable "user_to_output" {
  type = string
}
```

- Define a couple of outputs that allow us to visualize the information we have been processing so far. Run a
  `terraform plan` to visualize the changes.

```hcl
output "users_map" {
  value = local.users_map
}

output "users_map2" {
  value = local.users_map2
}

output "user_to_output_roles" {
  value = local.users_map2[var.user_to_output].roles
}
```

- Last but not least, create a local that transforms the `local.users_map` map into a list containing only the username
  of each map entry. Create a new output to show the information and run a `terraform plan` to visualize the results.

```hcl
locals = {
  # converting map into list 
  usernames_from_map = [for username, roles in local.users_map : username]
}

output "usernames_from_map" {
  value = local.userames_from_map
}
```