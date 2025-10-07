variable "okta_org_name" {
  description = "Okta organization name"
  type        = string
  sensitive   = true
}

variable "okta_base_url" {
  description = "Okta base URL (e.g., okta.com, oktapreview.com)"
  type        = string
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "Okta API token for authentication"
  type        = string
  sensitive   = true
}

variable "admin_user_id" {
  description = "Okta user ID for admin approvals"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "OIG-Demo"
  }
}
