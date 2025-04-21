locals {
  name = "Lauro Muller"
  age  = -15
  my_object = {
    key1 = 10
    key2 = "my_value"
  }
}

output "output1" {
  value = startswith(lower(local.name), "john")
}

output "output2" {
  value = pow(local.age, 2)
}

output "output3" {
  # first we use the yamldecode to load all users that defined in the users.yaml
  # then, `yamldecod` this built-in function will converted all array organized yaml elements into array
  # since all elements of user item are organized in array, we can use the splat operation upon the array item as `users[*]` to fetch all user items
  # and use `.name` to fetch all user's name and the name also organized in array of string.
  value = yamldecode(file("${path.module}/users.yaml")).users[*].name
}


output "output4" {
  # terraform built-in function jsonencoded will converted object item into json
  value = jsonencode(local.my_object)
}
