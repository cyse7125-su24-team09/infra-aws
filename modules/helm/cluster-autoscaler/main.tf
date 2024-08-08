resource "helm_release" "cluster_autoscaler" {
  name      = var.helm_release_config.name
  namespace = "kube-system"
  chart     = var.helm_release_config.chart
  values = [
    file(var.helm_release_config.values_file_path),
    yamlencode({
      rbac = {
        serviceAccount = {
          name = var.cluster_service_account_name
          annotations = {
            "eks.amazonaws.com/role-arn" = "${var.cluster_role_arn}"
          }
        }
      },
      extraArgs = {
        "nodeGroupAutoDiscovery" = "asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${var.cluster_name}"
      }
    })
  ]
}