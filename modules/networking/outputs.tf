output "vpc_id" {
  value = aws_vpc.infra_vpc.id
}

output "subnet_ids" {
  value = {
    public_subnets  = aws_subnet.public_subnet[*].id
    private_subnets = aws_subnet.private_subnet[*].id
  }
}

output "security_group_id" {
  value = aws_security_group.eks_sg.id
}