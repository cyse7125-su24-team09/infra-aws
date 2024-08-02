variable "istio_system_namespace" {
  type = string
}

variable "istio_ingress_namespace" {
  type = string
}

variable "helm_release_config" {
  description = "Helm release configuration for bootstrapping istio"
  type = object({
    values_file_path = string
  })
}