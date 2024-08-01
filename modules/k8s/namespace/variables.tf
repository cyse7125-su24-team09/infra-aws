variable "webapp_processor_namespace" {
  type = string
}

variable "webapp_consumer_namespace" {
  type = string
}

variable "kafka_namespace" {
  type = string
}

variable "operator_namespace" {
  type = string
}

variable "fluentbit_namespace" {
  type    = string
  default = "amazon-cloudwatch"
}