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

resource "kubernetes_namespace" "tracing" {
  metadata {
    name = "tracing"
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


resource "kubernetes_namespace" "eck_system" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "elastic-system"
  }
}

resource "kubernetes_namespace" "eck_stack" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "elastic-stack"
  }
}

resource "kubernetes_namespace" "llm_app" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "llm-app"
  }
}