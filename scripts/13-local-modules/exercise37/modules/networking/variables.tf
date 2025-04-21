variable "vpc_cidr" {
  type = string
  validation {
    condition = can(cidrnetmask(var.vpc_cidr))
    error_message = "The vpc_dir must contain a valid CIDR block."
  }
}
