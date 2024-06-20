data "aws_caller_identity" "current" {}

resource "aws_kms_key" "eks_secrets_cmek" {
  description              = "KMS key for encrypting secrets in EKS cluster"
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec

  tags = {
    Name = "${var.cluster_name}-eks-secrets-cmek"
  }
}

resource "aws_kms_alias" "eks_secrets_cmek_alias" {
  name          = "alias/${var.cluster_name}-eks-secrets-cmek"
  target_key_id = aws_kms_key.eks_secrets_cmek.id
}

resource "aws_kms_key_policy" "eks_secrets_cmek_policy" {
  key_id = aws_kms_key.eks_secrets_cmek.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_key" "eks_ebs_cmek" {
  description              = "KMS key for encrypting EBS volumes in EKS cluster"
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec

  tags = {
    Name = "${var.cluster_name}-eks-ebs-cmek"
  }
}

resource "aws_kms_alias" "eks_ebs_cmek_alias" {
  name          = "alias/${var.cluster_name}-eks-ebs-cmek"
  target_key_id = aws_kms_key.eks_ebs_cmek.id
}

resource "aws_kms_key_policy" "eks_ebs_cmek_policy" {
  key_id = aws_kms_key.eks_ebs_cmek.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}
