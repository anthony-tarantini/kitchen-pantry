terraform {
   required_providers {
      aws = {
         source  = "hashicorp/aws"
         version = "~> 5.22.0"
      }
   }

   required_version = ">= 1.6.2"
}

provider "aws" {
   region = var.aws_region
}

provider "aws" {
   alias = "acm"

   region = var.acm_region
}
