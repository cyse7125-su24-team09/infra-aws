resource "aws_vpc" "infra_aws_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "infra-aws-vpc"
  }
}
resource "aws_internet_gateway" "infra_aws_igw" {
  vpc_id = aws_vpc.infra_aws_vpc.id

  tags = {
    Name = "infra-aws-igw"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.infra_aws_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "infra-aws-public-subnet-${count.index + 1}"

  }
}


resource "aws_subnet" "private_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.infra_aws_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "infra-aws-private-subnet-${count.index + 1}"

  }
}

resource "aws_eip" "nat_eip" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"
  tags = {
    Name = "infra-aws-nat-eip-${count.index}"
  }
  depends_on = [aws_internet_gateway.infra_aws_igw]

}

resource "aws_nat_gateway" "infra_aws_nat" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "infra-aws-nat-gateway-${count.index}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.infra_aws_igw]
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
resource "aws_route_table_association" "public_rta_assc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.infra_aws_vpc.id
  route {
    cidr_block     = var.route_cidr_range
    nat_gateway_id = aws_nat_gateway.infra_aws_nat[count.index].id

  }
  tags = {
    Name = "infra-aws-private-route-table"
  }
}
resource "aws_route_table_association" "private_rta_assc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
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
