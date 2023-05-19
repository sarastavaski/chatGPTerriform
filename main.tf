provider "aws" {
  region = var.primary_region
}

module "primary_infra" {
  source       = "./modules/infra"
  region       = var.primary_region
  vpc_cidr     = var.primary_vpc_cidr
  public_cidr  = var.primary_public_cidr
  private_cidr = var.primary_private_cidr
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

module "secondary_infra" {
  source       = "./modules/infra"
  providers = {
    aws = aws.secondary
  }
  region       = var.secondary_region
  vpc_cidr     = var.secondary_vpc_cidr
  public_cidr  = var.secondary_public_cidr
  private_cidr = var.secondary_private_cidr
}

module "transit_gateways" {
  source               = "./modules/transit_gateways"

  providers = {
    aws.primary   = aws
    aws.secondary = aws.secondary
  }
  primary_region       = var.primary_region
  secondary_region     = var.secondary_region
  primary_vpc_id       = module.primary_infra.vpc_id
  secondary_vpc_id     = module.secondary_infra.vpc_id
  primary_subnet_ids   = module.primary_infra.private_subnet_ids
  secondary_subnet_ids = module.secondary_infra.private_subnet_ids
  primary_vpc_cidr     = var.primary_vpc_cidr
  secondary_vpc_cidr   = var.secondary_vpc_cidr
}

module "s3_buckets" {
  source       = "./modules/s3_buckets"
  providers = {
    aws.primary   = aws
    aws.secondary = aws.secondary
  }
  primary_region    = var.primary_region
  secondary_region  = var.secondary_region
}

module "cloudfront" {
  source               = "./modules/cloudfront"
  primary_region       = var.primary_region
  secondary_region     = var.secondary_region
  primary_bucket_arn   = module.s3_buckets.primary_bucket_arn
  secondary_bucket_arn = module.s3_buckets.secondary_bucket_arn
  primary_bucket_domain_name = module.s3_buckets.primary_bucket_domain_name
  secondary_bucket_domain_name = module.s3_buckets.secondary_bucket_domain_name
}
