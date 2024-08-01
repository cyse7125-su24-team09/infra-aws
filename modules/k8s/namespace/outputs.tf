output "istio_system_namespace" {
  value = kubernetes_namespace.istio_system.metadata[0].name
}

output "istio_ingress_namespace" {
  value = kubernetes_namespace.istio_ingress.metadata[0].name
}

output "monitoring_namespace" {
  value = kubernetes_namespace.monitoring.metadata[0].name
}
