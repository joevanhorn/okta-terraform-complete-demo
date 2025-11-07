resource "okta_user_base_schema_property" "tfer--user_property_city" {
  index       = "city"
  master      = "PROFILE_MASTER"
  permissions = "HIDE"
  required    = "false"
  title       = "City"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_costcenter" {
  index       = "costCenter"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Cost center"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_countrycode" {
  index       = "countryCode"
  master      = "PROFILE_MASTER"
  permissions = "HIDE"
  required    = "false"
  title       = "Country code"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_department" {
  index       = "department"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Department"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_displayname" {
  index       = "displayName"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Display name"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_division" {
  index       = "division"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Division"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_email" {
  index       = "email"
  master      = "PROFILE_MASTER"
  permissions = "READ_WRITE"
  required    = "true"
  title       = "Primary email"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_employeenumber" {
  index       = "employeeNumber"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Employee number"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_firstname" {
  index       = "firstName"
  master      = "PROFILE_MASTER"
  permissions = "READ_WRITE"
  required    = "true"
  title       = "First name"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_honorificprefix" {
  index       = "honorificPrefix"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Honorific prefix"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_honorificsuffix" {
  index       = "honorificSuffix"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Honorific suffix"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_lastname" {
  index       = "lastName"
  master      = "PROFILE_MASTER"
  permissions = "READ_WRITE"
  required    = "true"
  title       = "Last name"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_locale" {
  index       = "locale"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Locale"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_login" {
  index       = "login"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "true"
  title       = "Username"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_manager" {
  index       = "manager"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Manager"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_managerid" {
  index       = "managerId"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "ManagerId"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_middlename" {
  index       = "middleName"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Middle name"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_mobilephone" {
  index       = "mobilePhone"
  master      = "PROFILE_MASTER"
  permissions = "READ_WRITE"
  required    = "false"
  title       = "Mobile phone"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_nickname" {
  index       = "nickName"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Nickname"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_organization" {
  index       = "organization"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Organization"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_postaladdress" {
  index       = "postalAddress"
  master      = "PROFILE_MASTER"
  permissions = "HIDE"
  required    = "false"
  title       = "Postal Address"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_preferredlanguage" {
  index       = "preferredLanguage"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Preferred language"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_primaryphone" {
  index       = "primaryPhone"
  master      = "PROFILE_MASTER"
  permissions = "HIDE"
  required    = "false"
  title       = "Primary phone"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_profileurl" {
  index       = "profileUrl"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Profile Url"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_secondemail" {
  index       = "secondEmail"
  master      = "PROFILE_MASTER"
  permissions = "READ_WRITE"
  required    = "false"
  title       = "Secondary email"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_state" {
  index       = "state"
  master      = "PROFILE_MASTER"
  permissions = "HIDE"
  required    = "false"
  title       = "State"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_streetaddress" {
  index       = "streetAddress"
  master      = "PROFILE_MASTER"
  permissions = "HIDE"
  required    = "false"
  title       = "Street address"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_timezone" {
  index       = "timezone"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Time zone"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_title" {
  index       = "title"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "Title"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_usertype" {
  index       = "userType"
  master      = "PROFILE_MASTER"
  permissions = "READ_ONLY"
  required    = "false"
  title       = "User type"
  type        = "string"
  user_type   = "default"
}

resource "okta_user_base_schema_property" "tfer--user_property_zipcode" {
  index       = "zipCode"
  master      = "PROFILE_MASTER"
  permissions = "HIDE"
  required    = "false"
  title       = "Zip code"
  type        = "string"
  user_type   = "default"
}
