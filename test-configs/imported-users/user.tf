resource "okta_user" "tfer--user_00urf0s2ggl0Dl9M31d7" {
  custom_profile_attributes = "{}"
  email                     = "joe.vanhorn@okta.com"
  first_name                = "-"
  last_name                 = "-"
  login                     = "joe.vanhorn@okta.com"
  status                    = "ACTIVE"
}

resource "okta_user" "tfer--user_00urf0wlv4gPrKoBG1d7" {
  custom_profile_attributes = "{}"
  email                     = "demo.platform@okta.com"
  first_name                = "demo"
  last_name                 = "platform"
  login                     = "demo.platform@okta.com"
  status                    = "ACTIVE"
}

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
