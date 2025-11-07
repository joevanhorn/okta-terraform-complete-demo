# Main configuration using modules

terraform {
  required_version = ">= 1.9.0"
  
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 6.1.0"
    }
  }
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

# Import existing resources using modules
module "identity" {
  source = "./modules/identity"
  
  okta_org_name = var.okta_org_name
}

module "applications" {
  source = "./modules/applications"
  
  okta_org_name = var.okta_org_name
}

module "policies" {
  source = "./modules/policies"
  
  okta_org_name = var.okta_org_name
}
