variable "primary_region" {
  description = "Primary region for infrastructure"
}

variable "secondary_region" {
  description = "Secondary region for infrastructure"
}

variable "primary_vpc_id" {
  description = "VPC ID in the primary region"
}

variable "secondary_vpc_id" {
  description = "VPC ID in the secondary region"
}

variable "primary_subnet_ids" {
  description = "IDs of the primary region private subnets"
}

variable "secondary_subnet_ids" {
  description = "IDs of the secondary region private subnets"
}

variable "primary_vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for the VPC"
}


resource "aws_ec2_transit_gateway" "primary_transit_gateway" {
  description = "Primary region transit gateway"
  tags = {
    Name = "ski-chatgpt-infra-primary-tgw"
  }
}

resource "aws_ec2_transit_gateway" "secondary_transit_gateway" {
  description = "Secondary region transit gateway"
  provider    = aws.secondary
  tags = {
    Name = "ski-chatgpt-infra-secondary-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "primary_attachment" {
  transit_gateway_id       = aws_ec2_transit_gateway.primary_transit_gateway.id
  vpc_id                   = var.primary_vpc_id
  subnet_ids               = var.primary_subnet_ids
  dns_support              = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

resource "aws_ec2_transit_gateway_vpc_attachment" "secondary_attachment" {
  provider                 = aws.secondary
  transit_gateway_id       = aws_ec2_transit_gateway.secondary_transit_gateway.id
  vpc_id                   = var.secondary_vpc_id
  subnet_ids               = var.secondary_subnet_ids
  dns_support              = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
}

resource "aws_ec2_transit_gateway_peering_attachment" "peering_attachment" {
  transit_gateway_id      = aws_ec2_transit_gateway.primary_transit_gateway.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.secondary_transit_gateway.id
  peer_region             = var.secondary_region
  #peer_account_id        = var.secondary_account_id
  tags = {
    Name = "ski-chatgpt-infra-tgw-peering"
  }
}

resource "aws_ec2_transit_gateway_route_table" "primary_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.primary_transit_gateway.id
  tags = {
    Name = "ski-chatgpt-infra-tgw-peering"
  }
}

resource "aws_ec2_transit_gateway_route_table" "secondary_route_table" {
  provider           = aws.secondary
  transit_gateway_id = aws_ec2_transit_gateway.secondary_transit_gateway.id
  tags = {
    Name = "ski-chatgpt-infra-tgw-peering"
  }
}

resource "aws_ec2_transit_gateway_route" "primary_to_secondary_route" {
  transit_gateway_route_table_id    = aws_ec2_transit_gateway_route_table.primary_route_table.id
  destination_cidr_block            = var.secondary_vpc_cidr
  transit_gateway_attachment_id     = aws_ec2_transit_gateway_vpc_attachment.primary_attachment.id
}

resource "aws_ec2_transit_gateway_route" "secondary_to_primary_route" {
  provider                          = aws.secondary
  transit_gateway_route_table_id    = aws_ec2_transit_gateway_route_table.secondary_route_table.id
  destination_cidr_block            = var.primary_vpc_cidr
  transit_gateway_attachment_id     = aws_ec2_transit_gateway_vpc_attachment.secondary_attachment.id
}
