resource "aws_vpc" "infra_aws_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "infra-aws-vpc"
    }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet" {
    count             = length(var.public_subnet_cidrs)
    vpc_id            = aws_vpc.infra_aws_vpc.id
    cidr_block        = var.public_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available[count.index].name
    map_public_ip_on_launch = true

    tags = {
        Name = "infra-aws-public-subnet-${count.index + 1}"
         
    }
}


resource "aws_subnet" "private_subnet" {
    count             = length(var.public_subnet_cidrs)
    vpc_id            = aws_vpc.infra_aws_vpc.id
    cidr_block        = var.private_subnet_cidrs[count.index]
    availability_zone = data.aws_availability_zones.available[count.index].name
    tags = {
        Name = "infra-aws-private-subnet-${count.index + 1}"
         
    }
}

resource "aws_internet_gateway" "infra_aws_igw" {
    vpc_id = aws_vpc.infra_aws_vpc.id

    tags = {
        Name = "infra-aws-igw"
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.infra_aws_vpc.id
    route {
        cidr_block = var.route_cidr_range
        gateway_id = aws_internet_gateway.infra_aws_igw.id
    }
    tags = {
        Name = "infra-aws-public-route-table"
    }
}

resource "aws_route_table_association" "public_rta" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.infra_aws_route_table.id
}


resource "aws_security_group" "eks" {
  vpc_id = aws_vpc.infra_aws_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-security-group"
  }
}
