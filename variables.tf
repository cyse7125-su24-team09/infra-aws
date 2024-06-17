variable "aws_profile" {
  type        = string
  description = "AWS Profile Name"
}

variable "region" {
  type        = string
  description = "AWS Region Name"
}

variable "kms_key_usage" {
  type        = string
  description = "Intended use of KMS key"
}

variable "kms_customer_master_key_spec" {
  type        = string
  description = "Encryption algorithm of the KMS key"
}
