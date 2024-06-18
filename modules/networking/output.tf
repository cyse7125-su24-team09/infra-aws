output "vpc_id" {
  value = aws_vpc.infra_aws_vpc.id

}
output "subnet_ids" {
  value = concat(aws_subnet.private_subnet[*].id, aws_subnet.public_subnet[*].id)
}
output "eks_security_group_id" {
  value = aws_security_group.eks.id

}