module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "~> 20.0"
  cluster_name                    = var.cluster_name
  vpc_id                          = var.vpc_id
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_ip_family               = "ipv4"
  subnet_ids                      = var.subnet_ids
  cluster_enabled_log_types       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  create_kms_key                  = false
  iam_role_arn                    = var.eks_role_arn
  cluster_security_group_id       = var.security_group_id

  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = var.key_arn
  }

  authentication_mode = "API_AND_CONFIG_MAP"


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
    "ManagedBy"   = "Terraform"
  }

  eks_managed_node_groups = {
    eks_nodes = {
      ami_type         = "AL2_x86_64"
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "c3.large"
      #   key_name         = var.key_name
      volume_size     = 10
      volume_type     = "gp3"
      capacity_type   = "ON_DEMAND"
      max_unavailable = 1
      subnets         = var.subnet_ids
      tags = {
        "Name" = "eks-node-group"
      }
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }

    }
  }
  openid_connect_audiences = ["sts.amazonaws.com"]

}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "ebs-csi-driver-role"
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
            "${module.eks.oidc_provider}.token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
            "${module.eks.oidc_provider}.token.actions.githubusercontent.com:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_attachment" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
