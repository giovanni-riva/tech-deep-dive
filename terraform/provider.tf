terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.28.0"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
  access_key = "ASIAZQNB3KHGF4B4BBMH"
  secret_key = "jHvpnsLkejZWUQ5pbYJPe2yB7k6Tp6K2+GCH55UI"
}
