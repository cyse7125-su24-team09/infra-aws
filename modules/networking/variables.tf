variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "route_cidr_range" {
  type        = string
  description = "CIDR range for the route table"
  default     = "0.0.0.0/0"
}

variable "cluster_name" {
  type = string
}

variable "env" {
  type = string
}

variable "eks_security_group_rules" {
  description = "Security group rules for the EKS cluster"
  type = object({
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  })
}