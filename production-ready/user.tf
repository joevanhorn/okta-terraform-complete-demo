# Admin users (joe.vanhorn@okta.com, demo.platform@okta.com) have been
# filtered out to prevent accidental deletion via Terraform.
# These users are managed directly in the Okta console.

resource "okta_user" "tfer--user_00urfd91ncmFPEKoH1d7" {
  city                      = "San Francisco"
  country_code              = "US"
  custom_profile_attributes = "{}"
  department                = "Engineering"
  email                     = "john.doe@example.com"
  first_name                = "John"
  last_name                 = "Doe"
  login                     = "john.doe@example.com"
  mobile_phone              = "+14155551234"
  state                     = "CA"
  status                    = "ACTIVE"
  title                     = "Senior Software Engineer"
}

resource "okta_user" "tfer--user_00urfdcayfab8qED11d7" {
  city                      = "Boston"
  country_code              = "US"
  custom_profile_attributes = "{}"
  department                = "Security"
  email                     = "bob.johnson@example.com"
  first_name                = "Bob"
  last_name                 = "Johnson"
  login                     = "bob.johnson@example.com"
  mobile_phone              = "+16175554321"
  state                     = "MA"
  status                    = "ACTIVE"
  title                     = "Security Engineer"
}

resource "okta_user" "tfer--user_00urfddqbf5k0uQJG1d7" {
  city                      = "Austin"
  country_code              = "US"
  custom_profile_attributes = "{}"
  department                = "Sales"
  email                     = "jane.smith@example.com"
  first_name                = "Jane"
  last_name                 = "Smith"
  login                     = "jane.smith@example.com"
  mobile_phone              = "+15125559876"
  state                     = "TX"
  status                    = "ACTIVE"
  title                     = "Account Executive"
}

# NEW USERS - Added for production validation
resource "okta_user" "alice_williams" {
  city                      = "New York"
  country_code              = "US"
  custom_profile_attributes = "{}"
  department                = "Marketing"
  email                     = "alice.williams@example.com"
  first_name                = "Alice"
  last_name                 = "Williams"
  login                     = "alice.williams@example.com"
  mobile_phone              = "+12125551111"
  state                     = "NY"
  status                    = "ACTIVE"
  title                     = "Marketing Manager"
}

resource "okta_user" "david_chen" {
  city                      = "Seattle"
  country_code              = "US"
  custom_profile_attributes = "{}"
  department                = "DevOps"
  email                     = "david.chen@example.com"
  first_name                = "David"
  last_name                 = "Chen"
  login                     = "david.chen@example.com"
  mobile_phone              = "+12065552222"
  state                     = "WA"
  status                    = "ACTIVE"
  title                     = "DevOps Engineer"
}

resource "okta_user" "emma_rodriguez" {
  city                      = "Chicago"
  country_code              = "US"
  custom_profile_attributes = "{}"
  department                = "Product"
  email                     = "emma.rodriguez@example.com"
  first_name                = "Emma"
  last_name                 = "Rodriguez"
  login                     = "emma.rodriguez@example.com"
  mobile_phone              = "+13125553333"
  state                     = "IL"
  status                    = "ACTIVE"
  title                     = "Product Manager"
}
