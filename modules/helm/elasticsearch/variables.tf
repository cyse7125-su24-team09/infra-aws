variable "namespace" {
  type = string
}

variable "helm_release_config" {
  description = "Helm release configuration for bootstrapping fluent-bit"
  type = object({
    name             = string
    repository       = string
    chart            = string
    values_file_path = string
  })
}

variable "elasticsearch_secret" {
  description = "Elasticsearch secret configuration"
  type = object({
    filerealm = object({
      name        = string
      users       = string
      users_roles = string
    })
    roles = object({
      name = string
    })
  })

}