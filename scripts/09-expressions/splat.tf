locals {
  firstnames_from_splat = var.objects_list[*].firstname
  # splat operation only can be used in list operations
  # it does not support map operations
  roles_from_splat = [for username, user_props in local.user_list : user_props.role]

  # this operations is valid, because we use the inner function values() this function will extract all the value elements from the map
  # and converted all the value items into an array which supports splat operation to executed upon.
  roles_via_splat = values(local.users_map2)[*].role
}

output "firstnames_from_splat" {
  value = local.firstnames_from_splat
}

output "roles_from_splat" {
  value = local.roles_from_splat
}

output "roles_via_splat" {
  value = local.roles_via_splat
}
