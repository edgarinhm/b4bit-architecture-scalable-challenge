terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
    archive = {
      version = "~> 2.0"
      source  = "hashicorp/archive"
    }
    random = {
      version = "~> 3.0"
      source  = "hashicorp/random"
    }

  }
}
