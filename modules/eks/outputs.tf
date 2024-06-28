output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.eks_auth.token
}

output "oidc_provider" {
  value = module.eks.oidc_provider
}
