variable "key_usage" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "customer_master_key_spec" {
  description = "List of CIDR blocks for public subnets"
  type        = string
}
