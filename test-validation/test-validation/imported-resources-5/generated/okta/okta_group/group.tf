resource "okta_group" "tfer--group_All-0020-Employees" {
  custom_profile_attributes = "{}"
  description               = "All company employees"
  name                      = "All Employees"
}

resource "okta_group" "tfer--group_Engineering-0020-Team" {
  custom_profile_attributes = "{}"
  description               = "Engineering team members with access to development resources"
  name                      = "Engineering Team"
}

resource "okta_group" "tfer--group_Sales-0020-Team" {
  custom_profile_attributes = "{}"
  description               = "Sales team members"
  name                      = "Sales Team"
}

resource "okta_group" "tfer--group_Security-0020-Team" {
  custom_profile_attributes = "{}"
  description               = "Security team with access to security tools"
  name                      = "Security Team"
}
