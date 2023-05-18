data "aws_availability_zones" "available" {
  state = "available"
}

variable "region" {
  description = "AWS region"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "public_cidr" {
  description = "CIDR blocks for the VPC public subnets"
}

variable "private_cidr" {
  description = "CIDR blocks for the VPC private subnets"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "ski-chatgpt-infra"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  #availability_zone = var.region != "us-east-2" ? "${var.region}a" : "${var.region}b"
  tags = {
    Name = "ski-chatgpt-infra-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  #availability_zone = var.region != "us-east-2" ? "${var.region}a" : "${var.region}b"
  tags = {
    Name = "ski-chatgpt-infra-private-subnet-${count.index + 1}"
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}
