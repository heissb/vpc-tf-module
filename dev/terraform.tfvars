# AWS Configuration
aws_region = "us-west-2"
aws_profile = "dev"

# VPC Configuration
vpc_cidr = "172.16.0.0/16"

# Subnet Configuration
azs = ["us-west-2a", "us-west-2b"]
public_subnet_cidrs  = ["172.16.0.0/24", "172.16.1.0/24"]
private_subnet_cidrs = ["172.16.10.0/24", "172.16.11.0/24"]

# Common Tags
common_tags = {
  Environment = "dev"
  Project     = "vpc-module"
  Owner       = "devops-team"
}
