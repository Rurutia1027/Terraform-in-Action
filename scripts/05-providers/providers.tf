terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east"
}

provider "aws" {
  region = "ap-northeast-1"
}

# apply aws s3 bucket on default region
resource "aws_s3_bucket" "ap_northeast_1" {
  bucket = "my-aws-s3-bucket-ap-north-east"
}

# apply aws s3 bucket on us-east-1 which is alias as us-east
resource "aws_s3_bucket" "us_east_1" {
  bucket   = "my-aws-s3-bucket-us-east"
  provider = aws.us-east
}