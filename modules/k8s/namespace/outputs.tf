output "istio_system_namespace" {
  value = kubernetes_namespace.istio_system.metadata[0].name
}

output "istio_ingress_namespace" {
  value = kubernetes_namespace.istio_ingress.metadata[0].name
}

output "monitoring_namespace" {
  value = kubernetes_namespace.monitoring.metadata[0].name
}

output "tracing_namespace" {
  value = kubernetes_namespace.tracing.metadata[0].name
}

output "eck_elasticsearch" {
  value = kubernetes_namespace.eck_stack.metadata[0].name
}
