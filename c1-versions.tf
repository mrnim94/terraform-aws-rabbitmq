# Terraform AWS Provider Block
# provider "aws" {
#   region = var.aws_region
# }

# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.12"
     }
  }
}