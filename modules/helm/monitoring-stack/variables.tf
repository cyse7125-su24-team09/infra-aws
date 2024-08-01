variable "namespace" {
  type = string
}

variable "helm_release_config" {
  description = "Helm release configuration for bootstrapping monitoring stack"
  type = object({
    name             = string
    repository       = string
    chart            = string
    values_file_path = string
  })
}