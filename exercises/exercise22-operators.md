# Operators in Terraform

## Introduction

In this exercise, we will explore the different operators in Terraform. This exercise includes working with
mathematical, equality, comparison, and logical operators. You will get a chance to play around with these operators and
observe their behavior, which will give you a solid foundation for writing more complex Terraform configurations in the
future. Let's get started!

--- 

## Step-by-Step Guide

- Create a local block and play around with the math operators available in Terraform: `*, /, +, -, -<number>`. Their
  behavior is fairly straightforward, so there isn't much to explore here.
- Try the equality operators `==` and `!=`, which can be used to check whether two values are equal or not.
- Comparison operators are also available: `<, <=, >, >=`. Give it a try!
- Last but not least, play around with the logical operators, `&&`, `||` and `!`.

```hcl
locals {
  math       = 3 * 3
  equality   = 2 != 3
  comparison = 2 < 1
  logical    = true || false
}
```

- You can also output the values of these locals to inspect how they look like. Create an `output "operators"` block and
  run the `terraform plan` command to inspect the results.
```hcl
output "operators" {
  value = {
    math       = local.math
    equality   = local.equality
    comparison = local.comparison
    logical    = local.logical
  }
}
```

