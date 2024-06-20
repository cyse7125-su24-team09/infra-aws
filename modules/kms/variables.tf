variable "key_usage" {
  description = "Intended use of KMS key"
  type        = string
}

variable "customer_master_key_spec" {
  description = "Encryption algorithm of the KMS key"
  type        = string
}

variable "cluster_name" {
  type = string
}
