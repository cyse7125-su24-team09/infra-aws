#!/bin/bash
echo "Terraform Cleanup Started"

helm uninstall istio-ingressgateway -n istio-ingress
helm uninstall istiod -n istio-system
helm uninstall istio-base -n istio-system
helm uninstall kube-prometheus-stack -n monitoring
helm uninstall cve-kafka -n cve-kafka
helm uninstall cve-postgresql -n cve-consumer
helm uninstall cve-operator -n cve-operator
helm uninstall cve-processor -n cve-processor
helm uninstall cve-consumer -n cve-consumer

terraform state rm module.k8s_namespace
terraform state rm module.helm_istio

echo "Terraform Cleanup Complete"