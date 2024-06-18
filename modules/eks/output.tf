output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn


}

output "oidc_provider_url" {
  value = module.eks.oidc_provider
}