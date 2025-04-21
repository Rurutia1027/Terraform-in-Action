locals {
  math       = 2 * 2 - 2 * 1 + 1 / 5
  equality   = 2 == 3                # equality operators: == ; !=
  comparison = 2 <= 3                # >=, <= , <, >
  logical    = false || true && true # true, false
}

output "operator_rets" {
  value = {
    ret_math       = local.math
    ret_equality   = local.equality
    ret_comparison = local.comparison
    ret_logical    = local.logical
  }
}

locals {
  name = "Sebby"
  age  = 22
  my_object = {
    key1 = 10
    key2 = "my_inner_value"
    map = {
      a1     = "b"
      c2     = "d"
      value3 = "f"
    }
  }
}

locals {
  users = yamldecode(file("${path.module}/users.yaml"))
}


locals {
  user_list = var.users
}
output "output1" {
  value = startswith(lower(local.name), "se")
}

output "output2" {
  value = pow(local.age, 2)
}

output "output3" {
  value = yamldecode(file("${path.module}/users.yaml")).users[*].name
}

output "output4" {
  value = jsonencode(local.my_object)
}

output "output5" {
  value = local.user_list
}


