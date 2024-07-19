
resource "helm_release" "cluster_autoscaler" {
  name                = var.helm_release_config.name
  namespace           = "kube-system"
  repository          = var.helm_release_config.repository
  repository_username = var.github_user
  repository_password = var.github_token
  chart               = var.helm_release_config.chart
  version             = var.helm_release_config.version
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