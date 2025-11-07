resource "okta_policy_signon" "tfer--policy_signon_default-policy" {
  description     = "The default policy applies in all situations if no other policy applies."
  groups_included = ["00grf0wlpgwMSgIzt1d7"]
  name            = "Default Policy"
  priority        = "1"
  status          = "ACTIVE"
}
