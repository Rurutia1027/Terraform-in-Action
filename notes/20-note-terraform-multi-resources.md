# Terraform Creating Multiple Resource

**Avoid code duplication by leveraging count and for_each meta-arguments**.


--- 

### `count`: is used to define the number of instances of a specific resource Terraform should create.

- It csn be used with modules and with resources.
- Must be known before Terraform performs any remote resource actions.
- `<TYPE>.<LABEL>.<INDEX>` refers to a specific instance of a resource, while `<TYPE>.<LABEL>` refers to the resource as
  a whole.
- We can use `count.index` in the resource's arguments to retrieve the index of the specific instance.

  ```hcl
  # <TYPE>: aws_instance, <LABEL>: multiple, [<INDEX>] = [0, var.ec2_count - 1]
  resource "aws_instance" "multiple" {
    count         = var.ec2_count
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
  
    tags = {
      Project = local.project
      Name    = "${local.project}-${count.index}"
    }
  }
  ```

### `for_each` accepts a map or a set of strings and creates an instance or for each entry in the received expression

- We can access the key and value via the `each` object. Key and value are the same if the received value is a set.
- We should not use sensitive values as arguments to the `for_each` meta-argument.
- The `for_each` value must be known before Terraform performs any remote operations.
- We can chain `for_each` resources into other `for_each` expressions if we need to create multiple resources based on a
  map or set.

  ```hcl
  resource "aws_subnet" "main" {
    for_each   = var.subnet_config
    vpc_id     = aws_vpc.main.id
    cidr_block = each.value.cidr_block
  
    tags = {
      Project = local.project
      Name    = "${local.project}-${each.key}"
    }
  }
  ```