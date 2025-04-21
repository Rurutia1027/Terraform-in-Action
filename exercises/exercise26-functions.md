# Working with Functions

## Introduction

In this exercise, we will delve into the practical implementation of various functions in Terraform. We will explore how
to use built-in functions to manipulate and transform data types. This includes, among others, working with string
functions, mathematical computations, and file encoding and decoding functions. By the end of this exercise, you should
have a firm understanding of how to utilize these functions effectively in your Terraform scripts.

--- 

## Step-by-Step Guide

- Start by defining some local variables using the `locals` block. Declare a `name`, `age` and `my_object`, which
  contain reasonable primitive and object values.

```hcl
locals {
  name = "Lauro Muller"
  age  = 14
  my_object = {
    key1 = 10
    key2 = "my_value"
  }
}
```

- Additionally, create a `users.yaml` file with the following content:

```yaml
users:
  - name: Lauro
    group: developers
  - name: John
    group: auditors
```

- Create an output that uses the `startswith` function to check if the `local.name` starts with a certain value. Which
  function can we use to ensure the comparison is case-sensitive?

```hcl
output "example1" {
  value = startswith(lower(local.name), "john")
}
```

- Create another output block that calculates the square of `local.age` using the `pow` function.

```hcl
output "example2" {
  value = pow(local.age, 2)
}
```

- Create a third output block that uses the `yamldecode` function to decode the created YAML file named `users.yaml`
  within the module's path. Output a list containing only the `name` property of each object.

```hcl
output "example3" {
  value = yamldecode(file("${path.module}/users.yaml")).users[*].name
}
```

- Finally, create a fourth output block that uses the `jsoncode` function to convert `local.my_object` into a JSON
  string.

```hcl
output "example" {
  value = jsoncode(local.my_object)
}
```

--- 
## Reference

- [Terraform Built-in Functions](https://developer.hashicorp.com/terraform/language/functions)