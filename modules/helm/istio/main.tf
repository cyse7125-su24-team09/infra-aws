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
  values     = ["${file("./modules/helm/istio/values.yaml")}"]

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingress_gateway" {
  name       = "istio-ingress"
  namespace  = var.istio_ingress_namespace
  repository = local.istio_helm_repo
  chart      = "gateway"

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}