locals {
  double_numbers = [for item in var.numbers_list : (item * 2)]
  even_numbers   = [for num in var.numbers_list : num if num % 2 == 0]
  firstnames = [
    for person in var.objects_list : person.firstname
  ]
  fullname = [
    for person in var.objects_list : "${person.firstname} ${person.lastname}"
  ]
}

# assign corresponding output items for inner local expression results
output "double_numbers" {
  value = local.double_numbers
}

output "even_numbers" {
  value = local.even_numbers
}

output "firstnames" {
  value = local.firstnames
}

output "fullnames" {
  value = local.fullname
}