variable "aws_profile" {
  type        = string
  description = "AWS Profile Name"
}

variable "region" {
  type        = string
  description = "AWS Region Name"
}

variable "eks_security_group_rules" {
  description = "Security group rules for the EKS cluster"
  type = object({
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  })
}

variable "kms_key_usage" {
  type        = string
  description = "Intended use of KMS key"
}

variable "kms_customer_master_key_spec" {
  type        = string
  description = "Encryption algorithm of the KMS key"
}

variable "env" {
  type        = string
  description = "The environment in which the resources are created"
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "eks_cluster_endpoint_public_access" {
  type = bool
}

variable "eks_cluster_endpoint_private_access" {
  type = bool
}

variable "eks_cluster_ip_family" {
  type = string
}

variable "eks_cluster_enabled_log_types" {
  type = list(string)
}

variable "eks_openid_connect_audiences" {
  type = list(string)
}

variable "eks_authentication_mode" {
  type = string
}

variable "eks_node_group_ami_type" {
  type = string
}

variable "eks_node_group_instance_types" {
  type = list(string)
}

variable "eks_node_group_capacity_type" {
  type = string
}

variable "eks_node_group_desired_size" {
  type = number
}

variable "eks_node_group_min_size" {
  type = number
}

variable "eks_node_group_max_size" {
  type = number
}

variable "eks_node_group_disk_size" {
  type = number
}

variable "eks_node_group_max_unavailable" {
  type = number
}