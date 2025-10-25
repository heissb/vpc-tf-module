terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # backend "s3" {
  #   bucket = "my-super-state-bucket"
  #   key    = "dev/vpc.tfstate"
  #   region = "us-west-2"
  # }
  
}

provider "aws" {
  region  = var.aws_region

  #added for local testing without nees for aws configure
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
  
  default_tags {
    tags = var.common_tags
  }
}
