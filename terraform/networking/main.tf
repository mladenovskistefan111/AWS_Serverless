# --- networking/main.tf ---

# Create VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = false
  enable_dns_support   = false
  tags = {
    Name = var.vpc_name
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Create private subnets for Lambda

resource "aws_subnet" "private_subnets" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = each.value.name
  }
}