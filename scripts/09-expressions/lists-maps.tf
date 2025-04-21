locals {
  # user_map: key: username, value: user's one or multiple roles in list
  users_map = {
    for user_info in var.users : user_info.username => user_info.role...
  }

  # continue operation upon local to converted into a new local item
  users_map2 = {
    for username, roles in local.users_map : username => {
      roles = roles
    }
  }

  # create an array of usernames which are extracted from the local item
  # -- the map of the user with key as username, value as the roles assigned to the user
  usernmames_for_map = [for username, _ in local.users_map : username]
}

output "users_map" {



  value = local.users_map
}

output "users_map2" {
  value = local.users_map2
}

output "usernames_from_map" {
  value = local.usernmames_for_map
}

output "user_to_output_roles" {
  value = local.users_map2[var.user_to_output].roles
}