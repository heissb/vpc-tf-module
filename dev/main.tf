module "vpc" {
  source = "../modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = "dev"
  
  region      = var.aws_region
  azs         = var.azs
}
