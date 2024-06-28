resource "kubernetes_namespace" "webapp_processor_namespace" {
  metadata {
    name = var.webapp_processor_namespace
  }
}

resource "kubernetes_namespace" "webapp_consumer_namespace" {
  metadata {
    name = var.webapp_consumer_namespace
  }
}

resource "kubernetes_namespace" "kafka_namespace" {
  metadata {
    name = var.kafka_namespace
  }
}