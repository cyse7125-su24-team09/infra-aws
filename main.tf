module "networking" {
  source                   = "./modules/networking"
  env                      = var.env
  region                   = var.region
  cluster_name             = var.eks_cluster_name
  vpc_cidr                 = var.vpc_cidr
  route_cidr_range         = var.route_cidr_range
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_subnet_cidrs     = var.private_subnet_cidrs
  availability_zones       = var.availability_zones
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
  gpu_node_group_ami_type         = var.eks_gpu_node_group_ami_type
  gpu_node_group_instance_types   = var.eks_gpu_node_group_instance_types
  gpu_node_group_capacity_type    = var.eks_gpu_node_group_capacity_type
  gpu_node_group_desired_size     = var.eks_gpu_node_group_desired_size
  gpu_node_group_min_size         = var.eks_gpu_node_group_min_size
  gpu_node_group_max_size         = var.eks_gpu_node_group_max_size
  gpu_node_group_max_unavailable  = var.eks_gpu_node_group_max_unavailable
  cluster_role_arn                = module.iam.eks_cluster_service_role_arn
  node_group_role_arn             = module.iam.eks_node_group_role_arn
  secrets_kms_key_arn             = module.kms.eks_secrets_kms_key_arn
  ebs_kms_key_arn                 = module.kms.eks_ebs_kms_key_arn
  # autoscaler_namespace            = var.k8s_clusterAutoscaler_namespace
  service_account_name = var.autoscaler_service_account_name
  hosted_zone_Id       = var.dns_zone_id
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = "aws"
    env = {
      AWS_PROFILE = var.aws_profile
    }
  }
}

module "k8s_storage" {
  source                          = "./modules/k8s/storage"
  ebs_storage_class               = var.k8s_ebs_storage_class
  kms_key_arn                     = module.kms.eks_ebs_kms_key_arn
  ebs_storage_class_elasticsearch = var.k8s_ebs_storage_class_elasticsearch
  depends_on = [
    module.kms,
    module.eks
  ]
}

module "k8s_namespace" {
  source                     = "./modules/k8s/namespace"
  webapp_processor_namespace = var.k8s_webapp_processor_namespace
  webapp_consumer_namespace  = var.k8s_webapp_consumer_namespace
  kafka_namespace            = var.k8s_kafka_namespace
  operator_namespace         = var.k8s_operator_namespace
  fluentbit_namespace        = var.k8s_fluentbit_namespace
  depends_on = [
    module.eks,
    module.k8s_storage
  ]
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
      env = {
        AWS_PROFILE = var.aws_profile
      }
    }
  }
}

module "helm_cluster_autoscaler" {
  source                       = "./modules/helm/cluster-autoscaler"
  cluster_name                 = var.eks_cluster_name
  cluster_role_arn             = module.eks.cluster_autoscaler_role_arn
  cluster_service_account_name = var.autoscaler_service_account_name
  helm_release_config          = var.helm_cluster_autoscaler_release_config

  depends_on = [
    module.eks
  ]
}

module "helm_istio" {
  source                  = "./modules/helm/istio"
  istio_system_namespace  = module.k8s_namespace.istio_system_namespace
  istio_ingress_namespace = module.k8s_namespace.istio_ingress_namespace
  helm_release_config     = var.helm_istio_release_config

  depends_on = [
    module.eks,
    module.k8s_namespace
  ]
}

module "helm_monitoring_stack" {
  source              = "./modules/helm/monitoring-stack"
  namespace           = module.k8s_namespace.monitoring_namespace
  helm_release_config = var.helm_monitoring_stack_release_config

  depends_on = [
    module.eks,
    module.k8s_namespace,
    module.helm_istio
  ]
}

module "helm_kafka" {
  source              = "./modules/helm/kafka"
  namespace           = var.k8s_kafka_namespace
  helm_release_config = var.helm_kafka_release_config

  depends_on = [
    module.eks,
    module.k8s_namespace,
    module.helm_istio,
    module.helm_monitoring_stack
  ]
}

module "helm_postgres" {
  source              = "./modules/helm/postgres"
  namespace           = var.k8s_webapp_consumer_namespace
  helm_release_config = var.helm_postgres_release_config

  depends_on = [
    module.eks,
    module.k8s_namespace,
    module.k8s_storage,
    module.helm_istio,
    module.helm_monitoring_stack
  ]
}

module "helm_fluentbit" {
  source              = "./modules/helm/fluentbit"
  namespace           = var.k8s_fluentbit_namespace
  helm_release_config = var.helm_fluentbit_release_config

  depends_on = [
    module.eks,
    module.k8s_namespace,
    module.helm_istio,
  ]
}

module "helm_elasticsearch" {
  source               = "./modules/helm/elasticsearch"
  namespace            = module.k8s_namespace.eck_elasticsearch
  helm_release_config  = var.helm_elasticsearch_release_config
  elasticsearch_secret = var.helm_elasticsearch_secret

  depends_on = [
    module.eks,
    module.k8s_namespace,
    module.k8s_storage,
    module.helm_istio,
    module.helm_monitoring_stack
  ]
}