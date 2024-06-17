terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.region
}

data "aws_availability_zones" "available" {}