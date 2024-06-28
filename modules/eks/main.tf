module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_ip_family               = var.cluster_ip_family
  cluster_enabled_log_types       = var.cluster_enabled_log_types
  openid_connect_audiences        = var.openid_connect_audiences

  vpc_id                    = var.vpc_id
  subnet_ids                = concat(var.subnet_ids.public_subnets, var.subnet_ids.private_subnets)
  cluster_security_group_id = var.security_group_id

  create_iam_role = false
  iam_role_arn    = var.cluster_role_arn

  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = var.secrets_kms_key_arn
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = var.authentication_mode

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = aws_iam_role.ebs_csi_driver_role.arn
    }
  }

  cluster_tags = {
    "Environment" = var.env
  }

  eks_managed_node_groups = {
    eks_node_group = {
      cluster_name = var.cluster_name
      name         = "${var.cluster_name}-node-group"

      ami_type       = var.node_group_ami_type
      instance_types = var.node_group_instance_types
      capacity_type  = var.node_group_capacity_type
      desired_size   = var.node_group_desired_size
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      disk_size      = var.node_group_disk_size
      subnet_ids     = var.subnet_ids.private_subnets

      update_config = {
        max_unavailable = var.node_group_max_unavailable
      }

      tags = {
        "NodeGroup" = "${var.cluster_name}-node-group"
      }

      create_iam_role = false
      iam_role_arn    = var.node_group_role_arn
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = module.eks.cluster_name
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "${var.cluster_name}-ebs-csi-driver-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : module.eks.oidc_provider_arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${module.eks.oidc_provider}:aud" : "sts.amazonaws.com",
            "${module.eks.oidc_provider}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ebs_csi_driver_kms_policy" {
  name = "AmazonEBSCSIDriverKMSPolicy"
  role = aws_iam_role.ebs_csi_driver_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        Resource = [var.ebs_kms_key_arn],
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = [var.ebs_kms_key_arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_attachment" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
