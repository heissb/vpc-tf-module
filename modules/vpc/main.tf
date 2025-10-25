# VPC
resource "aws_vpc" "staging_vpc" {
  cidr_block           = var.vpc_cidr
}

# Endpoint for SSM
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.staging_vpc.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id
  
  security_group_ids = [
    aws_security_group.vpc_endpoints.id
  ]
}

# Security group for ssm
resource "aws_security_group" "vpc_endpoints" {
  name_prefix = "${var.environment}-vpc-endpoints-sg"
  vpc_id      = aws_vpc.staging_vpc.id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.staging_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  
  route_table_ids = concat(
    aws_route_table.private[*].id,
    [aws_route_table.public.id]
  )
}

# public subnets
resource "aws_subnet" "public" {
  count                   = length(var.azs)

  vpc_id                  = aws_vpc.staging_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.environment}-public-${var.azs[count.index]}"
  }
}

# private subnets
resource "aws_subnet" "private" {
  count             = length(var.azs)

  vpc_id            = aws_vpc.staging_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  
  tags = {
    Name = "${var.environment}-private-${var.azs[count.index]}"
  }
}

# public route table to share
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.staging_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# private route table for each private subnet
resource "aws_route_table" "private" {
  count  = length(var.azs)

  vpc_id = aws_vpc.staging_vpc.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.azs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate private subnets with private route tables
resource "aws_route_table_association" "private" {
  count          = length(var.azs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.staging_vpc.id
}

# NAT Gateway Elastic IPs
resource "aws_eip" "nat_eip" {
  count = length(var.azs)
  domain = "vpc"
}

# NAT Gateways for public subnets
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.azs)

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  depends_on = [aws_internet_gateway.igw]
}
