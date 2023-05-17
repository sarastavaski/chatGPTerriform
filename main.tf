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
