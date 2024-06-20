output "eks_secrets_kms_key_arn" {
  description = "ARN of the KMS key for encrypting EKS secrets"
  value       = aws_kms_key.eks_secrets_cmek.arn
}

output "eks_ebs_kms_key_arn" {
  description = "ARN of the KMS key for encrypting EBS volumes in EKS cluster"
  value       = aws_kms_key.eks_ebs_cmek.arn
}