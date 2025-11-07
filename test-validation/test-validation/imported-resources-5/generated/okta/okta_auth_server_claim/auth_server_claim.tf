resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlrycktipag1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "address"
  scopes                  = ["address"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wls0rvzsn1e1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "birthdate"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wls2xnptv4a1d7" {
  always_include_in_token = "true"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "email"
  scopes                  = ["email"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wls43qf94f01d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "email_verified"
  scopes                  = ["email"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wls6exmnvo71d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "family_name"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wls8cavtvwn1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "gender"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlsak5d87k21d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "given_name"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlscoosvaxr1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "locale"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlsegeyrngk1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "middle_name"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlsglowgfoa1d7" {
  always_include_in_token = "true"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "name"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlsiwcq5fhi1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "nickname"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlskucwq4f61d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "phone_number"
  scopes                  = ["phone"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlsmdvvkz8m1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "picture"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlsokjhrnfi1d7" {
  always_include_in_token = "true"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "preferred_username"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlsq0utms5r1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "profile"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlsszqaeke61d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "updated_at"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlsuzghsgef1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "website"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}

resource "okta_auth_server_claim" "tfer--auth-server-default-claim-oclrf0wlswkxhwbak1d7" {
  always_include_in_token = "false"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  claim_type              = "IDENTITY"
  name                    = "zoneinfo"
  scopes                  = ["profile"]
  status                  = "ACTIVE"
  value_type              = "SYSTEM"
}
