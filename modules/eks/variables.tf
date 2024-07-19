variable "env" {
  description = "The environment in which the resources are created"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID in which the EKS cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "The Subnet IDs in which the EKS cluster and node groups will be deployed"
  type = object({
    public_subnets  = list(string)
    private_subnets = list(string)
  })
}

variable "secrets_kms_key_arn" {
  description = "The ARN of the KMS key to use for EKS secrets encryption"
  type        = string
}

variable "ebs_kms_key_arn" {
  description = "The ARN of the KMS key to use for EBS data encryption using EBS CSI Driver"
  type        = string
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role to associate with the EKS cluster"
  type        = string
}

variable "node_group_role_arn" {
  description = "The ARN of the IAM role to associate with the EKS managed node group"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the EKS cluster"
  type        = string
}


variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "cluster_endpoint_public_access" {
  type = bool
}

variable "cluster_endpoint_private_access" {
  type = bool
}

variable "cluster_ip_family" {
  type = string
}

variable "cluster_enabled_log_types" {
  type = list(string)
}

variable "openid_connect_audiences" {
  type = list(string)
}

variable "authentication_mode" {
  type = string
}

variable "node_group_ami_type" {
  type = string
}

variable "node_group_instance_types" {
  type = list(string)
}

variable "node_group_capacity_type" {
  type = string
}

variable "node_group_desired_size" {
  type = number
}

variable "node_group_min_size" {
  type = number
}

variable "node_group_max_size" {
  type = number
}

variable "node_group_disk_size" {
  type = number
}

variable "node_group_max_unavailable" {
  type = number
}

# variable "autoscaler_namespace" {
#   type        = string
#   description = "namespace of the autoscaler"
# }

variable "service_account_name" {
  type        = string
  description = "name of service account used in Helm chart"
}