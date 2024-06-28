variable "ebs_storage_class" {
  description = "The k8s storage class configuration for EBS CSI driver"
  type = object({
    name                = string
    storage_provisioner = string
    reclaim_policy      = string
    volume_binding_mode = string
    parameters = object({
      type      = string
      fstype    = string
      encrypted = string
    })
  })
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for EBS data encryption using EBS CSI Driver"
  type        = string
}