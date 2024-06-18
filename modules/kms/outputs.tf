output "eks_secrets_kms_key_arn" {
  description = "ARN of the KMS key for encrypting EKS secrets"
  value       = aws_kms_key.eks_secrets_cmek.arn
}

output "ebs_kms_key_arn" {
  description = "ARN of the KMS key for encrypting EBS volumes"
  value       = aws_kms_key.ebs_cmek.arn
}