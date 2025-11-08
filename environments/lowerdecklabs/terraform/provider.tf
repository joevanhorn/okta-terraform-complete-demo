terraform {
  required_version = ">= 1.9.0"

  required_providers {
    okta = {
      source  = "okta/okta"
      version = ">= 6.4.0, < 7.0.0"  # Auto-update to latest 6.x
    }
  }

  # Configure backend for state storage
  # Uncomment and configure for your environment
  # backend "s3" {
  #   bucket = "my-terraform-state"
  #   key    = "okta/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}
