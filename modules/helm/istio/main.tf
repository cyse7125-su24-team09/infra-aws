locals {
  istio_helm_repo = "https://istio-release.storage.googleapis.com/charts"
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  namespace  = var.istio_system_namespace
  repository = local.istio_helm_repo
  chart      = "base"

  set {
    name  = "defaultRevision"
    value = "default"
  }
}

resource "helm_release" "istiod" {
  name       = "istiod"
  namespace  = var.istio_system_namespace
  repository = local.istio_helm_repo
  chart      = "istiod"
  wait       = true
  values     = ["${file(var.helm_release_config.values_file_path)}"]

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingressgateway"
  namespace  = var.istio_ingress_namespace
  repository = local.istio_helm_repo
  chart      = "gateway"

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}

# resource "kubernetes_manifest" "istio_gateway" {
#   manifest = yamldecode(file("${path.module}/istio-gateway.yaml"))

#   depends_on = [
#     helm_release.istio_ingressgateway
#   ]
# }

# resource "kubernetes_manifest" "grafana_virtual_service" {
#   manifest = yamldecode(file("${path.module}/grafana-virtualservice.yaml"))

#   depends_on = [
#     kubernetes_manifest.istio_gateway
#   ]
# }