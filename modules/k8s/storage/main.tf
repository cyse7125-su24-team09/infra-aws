resource "kubernetes_storage_class_v1" "ebs_gp3_storage_class" {
  metadata {
    name = var.ebs_storage_class.name
  }

  storage_provisioner = var.ebs_storage_class.storage_provisioner
  parameters = {
    type                        = var.ebs_storage_class.parameters.type
    "csi.storage.k8s.io/fstype" = var.ebs_storage_class.parameters.fstype
    encrypted                   = var.ebs_storage_class.parameters.encrypted
    kmsKeyId                    = var.kms_key_arn
  }
  reclaim_policy      = var.ebs_storage_class.reclaim_policy
  volume_binding_mode = var.ebs_storage_class.volume_binding_mode
}

resource "kubernetes_storage_class_v1" "ebs_gp3_storage_class_elasticsearch" {
  metadata {
    name = var.ebs_storage_class_elasticsearch.name
  }

  storage_provisioner = var.ebs_storage_class_elasticsearch.storage_provisioner
  parameters = {
    type                        = var.ebs_storage_class_elasticsearch.parameters.type
    "csi.storage.k8s.io/fstype" = var.ebs_storage_class_elasticsearch.parameters.fstype
    encrypted                   = var.ebs_storage_class_elasticsearch.parameters.encrypted
    kmsKeyId                    = var.kms_key_arn
  }
  reclaim_policy      = var.ebs_storage_class_elasticsearch.reclaim_policy
  volume_binding_mode = var.ebs_storage_class_elasticsearch.volume_binding_mode
}