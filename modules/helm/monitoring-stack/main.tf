resource "helm_release" "kube_prometheus_stack" {
  name       = var.helm_release_config.name
  namespace  = var.namespace
  repository = var.helm_release_config.repository
  chart      = var.helm_release_config.chart
  values     = ["${file(var.helm_release_config.values_file_path)}"]
}
