resource "okta_app_oauth" "tfer--oarf0wpg7nsfsace1d7-oidc-client" {
  accessibility_self_service = "false"
  app_links_json             = "{\"oidc_client_link\":true}"
  app_settings_json          = "{}"
  authentication_policy      = "rstrf0wlwjAEOO9IS1d7"
  auto_key_rotation          = "true"
  auto_submit_toolbar        = "false"
  client_id                  = "0oarf0wpg7NsFsacE1d7"
  consent_method             = "TRUSTED"
  grant_types                = ["client_credentials"]
  hide_ios                   = "true"
  hide_web                   = "true"
  implicit_assignment        = "false"
  issuer_mode                = "DYNAMIC"

  jwks {
    e   = "AQAB"
    kid = "demoplatform"
    kty = "RSA"
    n   = "lKl3Wk7VzPgARVBQnz1vL2o-2wTAlEEKlTRHsnUFD0zVhJ24jgP_4PNnpU289WTGufiP22Xtr0a4f58fWi_3GnGUlwH7MQDPbYBFgDrhMR7JdVjOlmYbpeGy0KheQ9K2Uz7B_8-eB3yQx8dt4RBel5Mn7vIarfNb2S0h6hWL4ouozqZ_dwgrKLL24QpOeXjwFqFZ0fIQuC7fLrsFhvT5GPf0aq-reX-KcVuTU1ozmiF8zdaN0L0L82vBY-8RLKdPIGdGqO9aA8rHoQozvxZfcHASS7L2EMSizu8sDUvM-Idms-ZqOJvC1CahlYJYhPm5DjVzQY68Q7zOXXz-mZX5Xw"
  }

  label                      = "Demo Platform Management"
  login_mode                 = "DISABLED"
  pkce_required              = "false"
  response_types             = ["token"]
  status                     = "ACTIVE"
  token_endpoint_auth_method = "private_key_jwt"
  type                       = "service"
  user_name_template         = "${source.login}"
  user_name_template_type    = "BUILT_IN"
  wildcard_redirect          = "DISABLED"
}

resource "okta_app_oauth" "tfer--oarf1km0tncsdlwh1d7-okta-iga-reviewer" {
  accessibility_self_service = "false"
  app_links_json             = "{\"login\":true}"
  app_settings_json          = "{}"
  authentication_policy      = "rstrf0wlwjAEOO9IS1d7"
  auto_submit_toolbar        = "false"
  hide_ios                   = "false"
  hide_web                   = "false"
  implicit_assignment        = "false"
  label                      = "Okta Access Certification Reviews"
  status                     = "ACTIVE"
  user_name_template         = "${source.login}"
  user_name_template_type    = "BUILT_IN"
}

resource "okta_app_oauth" "tfer--oarf1kr5tks4wmlh1d7-okta-flow-sso" {
  accessibility_self_service = "false"
  app_links_json             = "{\"workflow_login\":true}"
  app_settings_json          = "{\"initiateLoginURI\":\"https://demo-terraform-test-example.workflows.oktapreview.com/oidc/0oarf1kr5tKS4wmlh1d7/login\",\"redirectURI\":\"https://demo-terraform-test-example.workflows.oktapreview.com/oidc/0oarf1kr5tKS4wmlh1d7/cb\"}"
  authentication_policy      = "rstrf0wlwjAEOO9IS1d7"
  auto_submit_toolbar        = "false"
  hide_ios                   = "false"
  hide_web                   = "false"
  implicit_assignment        = "false"
  label                      = "Okta Workflows"
  status                     = "ACTIVE"
  user_name_template         = "${source.login}"
  user_name_template_type    = "BUILT_IN"
}

resource "okta_app_oauth" "tfer--oarf1kr9kflpyfzg1d7-okta-access-requests-resource-catalog" {
  accessibility_self_service = "false"
  app_settings_json          = "{}"
  authentication_policy      = "rstrf0wlwjAEOO9IS1d7"
  auto_submit_toolbar        = "false"
  hide_ios                   = "false"
  hide_web                   = "false"
  implicit_assignment        = "true"
  label                      = "Okta Identity Governance"
  status                     = "ACTIVE"
  user_name_template         = "${source.login}"
  user_name_template_type    = "BUILT_IN"
}

resource "okta_app_oauth" "tfer--oarf1krcc6rgayyr1d7-flow" {
  accessibility_self_service = "false"
  app_settings_json          = "{\"redirectURI\":\"https://oauth.workflows.oktapreview.com/oauth/okta/cb\",\"serviceDomain\":\"https://oauth.workflows.oktapreview.com\"}"
  authentication_policy      = "rstrf0wlwjAEOO9IS1d7"
  auto_submit_toolbar        = "false"
  hide_ios                   = "true"
  hide_web                   = "true"
  implicit_assignment        = "false"
  label                      = "Okta Workflows OAuth"
  status                     = "ACTIVE"
  user_name_template         = "${source.login}"
  user_name_template_type    = "BUILT_IN"
}

resource "okta_app_oauth" "tfer--oarf1tnyf8rtprw91d7-okta-atspoke-sso" {
  accessibility_self_service = "false"
  app_links_json             = "{\"login\":true}"
  app_settings_json          = "{\"initiateLoginURI\":\"https://demo-terraform-test-example.at.oktapreview.com/oidc/0oarf1tnyf8RtPrw91d7/login\",\"redirectURI\":\"https://demo-terraform-test-example.at.oktapreview.com/oidc/0oarf1tnyf8RtPrw91d7/cb\"}"
  authentication_policy      = "rstrf0wlwjAEOO9IS1d7"
  auto_submit_toolbar        = "false"
  hide_ios                   = "false"
  hide_web                   = "false"
  implicit_assignment        = "false"
  label                      = "Okta Access Requests"
  status                     = "ACTIVE"
  user_name_template         = "${source.login}"
  user_name_template_type    = "BUILT_IN"
}

resource "okta_app_oauth" "tfer--oarfddbqbmyn6avt1d7-oidc-client" {
  accessibility_self_service = "false"
  app_links_json             = "{\"oidc_client_link\":true}"
  app_settings_json          = "{}"
  authentication_policy      = "rstrf0wlwjAEOO9IS1d7"
  auto_key_rotation          = "true"
  auto_submit_toolbar        = "false"
  client_id                  = "0oarfddbqbmYn6AvT1d7"
  client_uri                 = "https://internalcrm.example.com"
  consent_method             = "REQUIRED"
  grant_types                = ["authorization_code", "refresh_token"]
  hide_ios                   = "true"
  hide_web                   = "true"
  implicit_assignment        = "false"
  issuer_mode                = "ORG_URL"
  label                      = "Internal CRM System"
  login_mode                 = "DISABLED"
  pkce_required              = "false"
  post_logout_redirect_uris  = ["https://internalcrm.example.com/logout"]
  redirect_uris              = ["https://internalcrm.example.com/callback"]
  refresh_token_rotation     = "STATIC"
  response_types             = ["code"]
  status                     = "ACTIVE"
  token_endpoint_auth_method = "client_secret_basic"
  type                       = "web"
  user_name_template         = "${source.login}"
  user_name_template_type    = "BUILT_IN"
  wildcard_redirect          = "DISABLED"
}

resource "okta_app_oauth" "tfer--oarfdfd50fkbr9vl1d7-oidc-client" {
  accessibility_self_service = "false"
  app_links_json             = "{\"oidc_client_link\":true}"
  app_settings_json          = "{}"
  authentication_policy      = "rstrf0wlwjAEOO9IS1d7"
  auto_key_rotation          = "true"
  auto_submit_toolbar        = "false"
  client_id                  = "0oarfdfd50FkbR9Vl1d7"
  client_uri                 = "https://projectmanagement.example.com"
  consent_method             = "REQUIRED"
  grant_types                = ["authorization_code", "refresh_token"]
  hide_ios                   = "true"
  hide_web                   = "true"
  implicit_assignment        = "false"
  issuer_mode                = "ORG_URL"
  label                      = "Project Management Tool"
  login_mode                 = "DISABLED"
  pkce_required              = "false"
  post_logout_redirect_uris  = ["https://projectmanagement.example.com/logout"]
  redirect_uris              = ["https://projectmanagement.example.com/callback"]
  refresh_token_rotation     = "STATIC"
  response_types             = ["code"]
  status                     = "ACTIVE"
  token_endpoint_auth_method = "client_secret_basic"
  type                       = "web"
  user_name_template         = "${source.login}"
  user_name_template_type    = "BUILT_IN"
  wildcard_redirect          = "DISABLED"
}
