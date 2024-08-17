resource "kubernetes_namespace" "webapp_processor" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = var.webapp_processor_namespace
  }
}

resource "kubernetes_namespace" "webapp_consumer" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = var.webapp_consumer_namespace
  }
}

resource "kubernetes_namespace" "kafka" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = var.kafka_namespace
  }
}

resource "kubernetes_namespace" "operator" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = var.operator_namespace
  }
}

resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "istio-ingress"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "amazon_cloudwatch" {
  metadata {
    name = var.fluentbit_namespace
  }
}

resource "kubernetes_namespace" "llm_service" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "llm-service"
  }
}


resource "kubernetes_namespace" "eck" {
  metadata {
    name = "elastic-system"
  }

}

resource "kubernetes_namespace" "eck_elasticsearch" {
  metadata {
    name = "elastic-stack"
  }

}