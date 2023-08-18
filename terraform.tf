terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "enclaive"
      Owner       = var.owner
      Terraform   = "true"
    }
  }
}
