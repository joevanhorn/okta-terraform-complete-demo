resource "okta_auth_server_scope" "tfer--auth-server-default-scope-address" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "This allows the app to view your address, such as: street address, city, state, and zip code."
  display_name     = "View your address."
  metadata_publish = "ALL_CLIENTS"
  name             = "address"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-device-sso" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "This allows you to single sign on between native client applications on your device."
  display_name     = "Request device secret."
  metadata_publish = "ALL_CLIENTS"
  name             = "device_sso"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-email" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "This allows the app to view your email address."
  display_name     = "View your email address."
  metadata_publish = "ALL_CLIENTS"
  name             = "email"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-offline-access" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "This keeps you signed in to the app, even when you are not using it."
  display_name     = "Keep you signed in to the app."
  metadata_publish = "ALL_CLIENTS"
  name             = "offline_access"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-okta-myaccount-appauthenticator-maintenance-manage" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "Allows the end user to manage non-sensitive attributes of their app authenticator enrollment."
  display_name     = "Manage non-sensitive attributes of my account app authenticator enrollment"
  metadata_publish = "ALL_CLIENTS"
  name             = "okta.myAccount.appAuthenticator.maintenance.manage"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-okta-myaccount-appauthenticator-maintenance-read" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "Allows the end user to read non-sensitive attributes of their app authenticator enrollment."
  display_name     = "Read non-sensitive attributes of my account app authenticator enrollment"
  metadata_publish = "ALL_CLIENTS"
  name             = "okta.myAccount.appAuthenticator.maintenance.read"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-okta-myaccount-appauthenticator-manage" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "Allows the end user to manage their app authenticator enrollment."
  display_name     = "Manage my account app authenticator enrollment"
  metadata_publish = "ALL_CLIENTS"
  name             = "okta.myAccount.appAuthenticator.manage"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-okta-myaccount-appauthenticator-read" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "Allows the end user to read their app authenticator enrollment."
  display_name     = "Read my account app authenticator enrollment"
  metadata_publish = "ALL_CLIENTS"
  name             = "okta.myAccount.appAuthenticator.read"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-openid" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "Signals that a request is an OpenID request."
  display_name     = "openid"
  metadata_publish = "ALL_CLIENTS"
  name             = "openid"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-phone" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "This allows the app to view your phone number."
  display_name     = "View your phone number."
  metadata_publish = "ALL_CLIENTS"
  name             = "phone"
  optional         = "false"
}

resource "okta_auth_server_scope" "tfer--auth-server-default-scope-profile" {
  auth_server_id   = "ausrf0wlrneummJky1d7"
  consent          = "IMPLICIT"
  default          = "false"
  description      = "The exact data varies based on what profile information you have provided, such as: name, time zone, picture, or birthday."
  display_name     = "View your profile information."
  metadata_publish = "ALL_CLIENTS"
  name             = "profile"
  optional         = "false"
}
