variable "primary_region" {
  description = "Primary region for infrastructure"
  default     = "us-east-2"
}

variable "secondary_region" {
  description = "Secondary region for infrastructure"
  default     = "eu-west-1"
}

variable "primary_vpc_cidr" {
  description = "CIDR block for the primary VPC"
  default     = "10.0.0.0/20"
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for the secondary VPC"
  default     = "10.16.0.0/20"
}

variable "primary_public_cidr" {
  description = "CIDR blocks for the primary VPC public subnets"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "primary_private_cidr" {
  description = "CIDR blocks for the primary VPC private subnets"
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "secondary_public_cidr" {
  description = "CIDR blocks for the secondary VPC public subnets"
  default     = ["10.16.0.0/24", "10.16.1.0/24", "10.16.2.0/24"]
}

variable "secondary_private_cidr" {
  description = "CIDR blocks for the secondary VPC private subnets"
  default     = ["10.16.10.0/24", "10.16.11.0/24", "10.16.12.0/24"]
}
