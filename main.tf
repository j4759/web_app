terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn     = var.deployment_role_arn
    session_name = "terraform_app_deployment"
  }
}

terraform {
  backend "s3" {
    # bucket = "<if deploying locally add bucket name here>"
    key    = "terraformstatefile"
    region = "eu-west-1"
  }
}


