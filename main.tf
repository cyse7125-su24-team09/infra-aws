module "networking" {
  source = "./modules/networking"
}

module "kms" {
  source                   = "./modules/kms"
    key_usage                = var.kms_key_usage
  customer_master_key_spec = var.kms_customer_master_key_spec
}