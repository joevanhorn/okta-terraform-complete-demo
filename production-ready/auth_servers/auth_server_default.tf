resource "okta_auth_server_default" "tfer--auth_server_default" {
  audiences                 = ["api://default"]
  credentials_rotation_mode = "AUTO"
  description               = "Default Authorization Server for your Applications"
  issuer_mode               = "ORG_URL"
  name                      = "default"
  status                    = "ACTIVE"
}
