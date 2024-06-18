module "networking" {
  source = "./modules/networking"
}

module "kms" {
  source                   = "./modules/kms"
  key_usage                = var.kms_key_usage
  customer_master_key_spec = var.kms_customer_master_key_spec
}

module "iam" {
  source = "./modules/iam"
}
module "eks" {
  source            = "./modules/eks"
  cluster_name      = var.cluster_name
  vpc_id            = module.networking.vpc_id
  subnet_ids        = module.networking.subnet_ids
  key_arn           = module.kms.eks_secrets_kms_key_arn
  env               = var.env
  eks_role_arn      = module.iam.eks_cluster_service_role_arn
  security_group_id = module.networking.eks_security_group_id
}