provider "okta" {
  version = "~> 6.1.0"
}

terraform {
	required_providers {
		okta = {
	    version = "~> 6.1.0"
		}
  }
}
