# variable "namespace" {
#   type = string
# }

variable "cluster_name" {
  type = string
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role to associate with the EKS cluster autoscaler"
  type        = string
}

variable "cluster_service_account_name" {
  description = "The name of the service account to associate with the EKS cluster autoscaler"
  type        = string
}

variable "helm_release_config" {
  description = "Helm release configuration for bootstrapping EKS cluster autoscaler"
  type = object({
    name             = string
    repository       = string
    chart            = string
    version          = string
    values_file_path = string
  })
}

variable "github_user" {
  description = "Github username"
  type        = string
}

variable "github_token" {
  description = "Github personal access token"
  type        = string
}
