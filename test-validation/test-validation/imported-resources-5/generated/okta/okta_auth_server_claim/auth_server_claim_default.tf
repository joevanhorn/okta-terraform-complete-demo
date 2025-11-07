resource "okta_auth_server_claim_default" "tfer--auth-server-default-claim-oclrf0wlrwq804q2p1d7" {
  always_include_in_token = "true"
  auth_server_id          = "ausrf0wlrneummJky1d7"
  name                    = "sub"
  value                   = "(appuser != null) ? appuser.userName : app.clientId"
}
