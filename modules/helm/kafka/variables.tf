variable "namespace" {
  type = string
}

variable "helm_release_config" {
  description = "Helm release configuration for bootstrapping kafka"
  type = object({
    name             = string
    repository       = string
    chart            = string
    version          = string
    values_file_path = string
  })
}