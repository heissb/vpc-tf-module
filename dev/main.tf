module "vpc" {
  source = "../modules/vpc"

  vpc_cidr            = var.vpc_cidr
  environment         = "dev"
  region              = var.aws_region
  azs                 = var.azs
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}
