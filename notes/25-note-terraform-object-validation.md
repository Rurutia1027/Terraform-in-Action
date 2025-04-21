# Notes for Terraform _Object Validation_

**More reliable infrastructure through pre and postconditions, and check assertions.

## Preconditions

- Preconditions are used from within **resources** and **data** blocks.
- Cannot reference the resource itself.
- Can be used to check the validity of data blocks or variables that the resource references.

```hcl
lifecycle {
  precondition {
    condition     = ""
    error_message = ""
  }
}
```

## Postconditions

- Postconditions are used from within **resources** and **data** blocks.
- Can reference the resource itself.
- Can be used to check the validity of the resource's configuraiton.

```hcl
lifecycle {
  postcondition {
    condition     = ""
    error_message = ""
  }
}
```

## Check assertions

- Used from outside **resources** and **data** blocks.
- Can reference information from across the current Terraform project.
- Results only in a **warning** and does not stop the apply process.

```hcl
check "my_custom_check" {
  assertion {
    condition     = ""
    error_message = ""
  }
}
```