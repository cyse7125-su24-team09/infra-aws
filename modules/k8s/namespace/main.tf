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
resource "kubernetes_namespace" "operator_namespace" {
  metadata {
    name = var.operator_namespace
  }
}

resource "kubernetes_namespace" "amazon_cloudwatch" {

  metadata {
    name = var.fluentbit_namespace
  }

}