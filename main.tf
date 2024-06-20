module "networking" {
  source                   = "./modules/networking"
  env                      = var.env
  cluster_name             = var.eks_cluster_name
  eks_security_group_rules = var.eks_security_group_rules
}

module "kms" {
  source                   = "./modules/kms"
  key_usage                = var.kms_key_usage
  customer_master_key_spec = var.kms_customer_master_key_spec
  cluster_name             = var.eks_cluster_name
}

module "iam" {
  source       = "./modules/iam"
  cluster_name = var.eks_cluster_name
}

module "eks" {
  source                          = "./modules/eks"
  env                             = var.env
  vpc_id                          = module.networking.vpc_id
  subnet_ids                      = module.networking.subnet_ids
  security_group_id               = module.networking.security_group_id
  cluster_name                    = var.eks_cluster_name
  cluster_version                 = var.eks_cluster_version
  cluster_endpoint_public_access  = var.eks_cluster_endpoint_public_access
  cluster_endpoint_private_access = var.eks_cluster_endpoint_private_access
  cluster_ip_family               = var.eks_cluster_ip_family
  cluster_enabled_log_types       = var.eks_cluster_enabled_log_types
  openid_connect_audiences        = var.eks_openid_connect_audiences
  authentication_mode             = var.eks_authentication_mode
  node_group_ami_type             = var.eks_node_group_ami_type
  node_group_instance_types       = var.eks_node_group_instance_types
  node_group_capacity_type        = var.eks_node_group_capacity_type
  node_group_desired_size         = var.eks_node_group_desired_size
  node_group_min_size             = var.eks_node_group_min_size
  node_group_max_size             = var.eks_node_group_max_size
  node_group_disk_size            = var.eks_node_group_disk_size
  node_group_max_unavailable      = var.eks_node_group_max_unavailable
  cluster_role_arn                = module.iam.eks_cluster_service_role_arn
  node_group_role_arn             = module.iam.eks_node_group_role_arn
  secrets_kms_key_arn             = module.kms.eks_secrets_kms_key_arn
  ebs_kms_key_arn                 = module.kms.eks_ebs_kms_key_arn
}