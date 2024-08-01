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

variable "k8s_webapp_processor_namespace" {
  description = "The k8s namespace to create in EKS cluster for cve processor webapp"
  type        = string
}

variable "k8s_webapp_consumer_namespace" {
  description = "The k8s namespace to create in EKS cluster for cve consumer webapp"
  type        = string
}

variable "k8s_kafka_namespace" {
  description = "The k8s namespace to create in EKS cluster for cve kafka"
  type        = string
}

variable "k8s_operator_namespace" {
  description = "The k8s namespace to create in EKS cluster for cve operator"
  type        = string
}

variable "k8s_fluentbit_namespace" {
  description = "The k8s namespace to create in EKS cluster for fluentbit"
  type        = string
  default     = "amazon-cloudwatch"
}

variable "k8s_ebs_storage_class" {
  description = "The k8s storage class configuration for EBS CSI driver"
  type = object({
    name                = string
    storage_provisioner = string
    reclaim_policy      = string
    volume_binding_mode = string
    parameters = object({
      type      = string
      fstype    = string
      encrypted = string
    })
  })
}

variable "helm_postgres_release_config" {
  description = "Helm release configuration for bootstrapping postgres database"
  type = object({
    name             = string
    repository       = string
    chart            = string
    version          = string
    values_file_path = string
  })
}

variable "helm_kafka_release_config" {
  description = "Helm release configuration for bootstrapping kafka"
  type = object({
    name             = string
    repository       = string
    chart            = string
    version          = string
    values_file_path = string
  })
}

variable "helm_cluster_autoscaler_release_config" {
  description = "Helm release configuration for bootstrapping EKS cluster autoscaler"
  type = object({
    name             = string
    chart            = string
    values_file_path = string
  })
}

variable "helm_fluentbit_release_config" {
  description = "Helm release configuration for bootstrapping fluent-bit"
  type = object({
    name             = string
    repository       = string
    chart            = string
    version          = string
    values_file_path = string
  })
}

variable "autoscaler_service_account_name" {
  description = "The name of the service account to associate with the EKS cluster autoscaler"
  type        = string
  default     = "cluster-autoscaler-sa"
}

variable "github_user" {
  description = "Github username"
  type        = string
}

variable "github_token" {
  description = "Github personal access token"
  type        = string
}

variable "helm_monitoring_stack_release_config" {
  description = "Helm release configuration for bootstrapping monitoring stack"
  type = object({
    name             = string
    repository       = string
    chart            = string
    values_file_path = string
  })

}