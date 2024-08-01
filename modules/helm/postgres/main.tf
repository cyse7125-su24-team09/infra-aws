resource "helm_release" "postgres" {
  name       = var.helm_release_config.name
  namespace  = var.namespace
  repository = var.helm_release_config.repository
  chart      = var.helm_release_config.chart
  version    = var.helm_release_config.version
  values     = ["${file(var.helm_release_config.values_file_path)}"]
}