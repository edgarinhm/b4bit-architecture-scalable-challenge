terraform {
  required_version = "~> 1.5"
  backend "s3" {
    bucket       = "data-architecture-terraform-state-bucket"
    region       = "us-east-1"
    key          = "PROD/s3-github-actions/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
