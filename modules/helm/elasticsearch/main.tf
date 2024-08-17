resource "kubernetes_secret" "my_filerealm_secret" {
  metadata {
    name      = var.elasticsearch_secret.filerealm.name
    namespace = var.namespace
  }

  data = {
    users       = var.elasticsearch_secret.filerealm.users
    users_roles = var.elasticsearch_secret.filerealm.users_roles
  }
}

resource "kubernetes_secret" "my_roles_secret" {
  metadata {
    name      = var.elasticsearch_secret.roles.name
    namespace = var.namespace
  }

  data = {
    "roles.yml" = file("${path.module}/roles.yaml")
  }
}
resource "helm_release" "elastic_operator" {
  name       = "eck-operator"
  repository = "https://helm.elastic.co"
  chart      = "eck-operator"
  namespace  = "elastic-system"
  depends_on = [kubernetes_secret.my_filerealm_secret, kubernetes_secret.my_roles_secret]
}

resource "helm_release" "elasticsearch" {
  name       = var.helm_release_config.name
  namespace  = var.namespace
  repository = var.helm_release_config.repository
  chart      = var.helm_release_config.chart
  wait       = false
  timeout    = 600
  values     = ["${file(var.helm_release_config.values_file_path)}"]
  depends_on = [helm_release.elastic_operator]
}