variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID in which the EKS cluster will be deployed"
  type        = string

}

variable "subnet_ids" {
  description = "The Subnet IDs in which the EKS cluster will be deployed"
  type        = list(string)

}

variable "key_arn" {
  description = "The ARN of the KMS key to use for encryption"
  type        = string
}

variable "env" {
  description = "The environment in which the resources are created"
  type        = string

}

variable "eks_role_arn" {
  description = "The ARN of the IAM role to associate with the EKS cluster"
  type        = string

}

variable "security_group_id" {
  description = "The ID of the security group to associate with the EKS cluster"
  type        = string
}