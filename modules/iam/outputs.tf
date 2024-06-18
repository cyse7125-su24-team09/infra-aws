output "eks_cluster_service_role_arn" {
  value = aws_iam_role.eks_cluster_service_role.arn
}

output "eks_node_group_role_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}