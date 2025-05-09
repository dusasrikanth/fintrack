provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "realops-vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
  }
}

# Subnet
resource "aws_subnet" "realops-public-subnet1" {
  vpc_id            = aws_vpc.realops-vpc.id
  cidr_block        = var.realops-public-subnet1_cidr
  availability_zone = "ap-south-1a"
  tags = {
    Name = "${var.realops-public-subnet1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "realops-igw" {
  vpc_id = aws_vpc.realops-vpc.id
}

# Route Table
resource "aws_route_table" "realops-public-rt" {
  vpc_id = aws_vpc.realops-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.realops-igw.id
  }

}

# Route Table Association
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.realops-public-subnet1.id
  route_table_id = aws_route_table.realops-public-rt.id
}

# Security Group
resource "aws_security_group" "realops-sg1" {
  vpc_id = aws_vpc.realops-vpc.id
  name   = var.sg_name

}

# Inbound security Group Rule 1
resource "aws_vpc_security_group_ingress_rule" "ssh-rule" {
  security_group_id = aws_security_group.realops-sg1.id

  cidr_ipv4   = "0.0.0.0/0"
  description = "SSH access"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

}

# Inbound security Group Rule 2
resource "aws_vpc_security_group_ingress_rule" "postgresDB-inbound" {
  security_group_id = aws_security_group.realops-sg1.id

  cidr_ipv4   = "0.0.0.0/0"
  description = "Allow 5432"
  from_port   = 5432
  ip_protocol = "tcp"
  to_port     = 5432

}

# Outbound security group rule 1
resource "aws_vpc_security_group_egress_rule" "Outbound-any" {
  security_group_id = aws_security_group.realops-sg1.id

  cidr_ipv4   = "0.0.0.0/0"
  description = "Any"
  ip_protocol = "-1"

}