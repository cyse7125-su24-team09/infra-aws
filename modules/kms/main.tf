data "aws_caller_identity" "current" {}

resource "aws_kms_key" "eks_secrets_cmek" {
  description              = "KMS key for encrypting secrets in Amazon EKS cluster"
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec

  tags = {
    Name = "eks-secrets-cmek"
  }
}

resource "aws_kms_alias" "eks_secrets_cmek_alias" {
  name          = "alias/eks-secrets-cmek"
  target_key_id = aws_kms_key.eks_secrets_cmek.id
}

resource "aws_kms_key_policy" "eks_secrets_cmek_policy" {
  key_id = aws_kms_key.eks_secrets_cmek.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
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

resource "aws_kms_key" "ebs_cmek" {
  description              = "KMS key for encrypting EBS volumes"
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec

  tags = {
    Name = "ebs-cmek"
  }
}

resource "aws_kms_alias" "ebs_cmek_alias" {
  name          = "alias/ebs-cmek"
  target_key_id = aws_kms_key.ebs_cmek.id
}

resource "aws_kms_key_policy" "ebs_cmek_policy" {
  key_id = aws_kms_key.ebs_cmek.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
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
