resource "okta_policy_mfa_default" "tfer--policy_mfa_default-policy" {
  is_oie = "false"

  okta_otp = {
    consent_type = "NONE"
    enroll       = "OPTIONAL"
  }

  okta_password = {
    consent_type = "NONE"
    enroll       = "REQUIRED"
  }

  okta_push = {
    consent_type = "NONE"
    enroll       = "OPTIONAL"
  }

  okta_sms = {
    consent_type = "NONE"
    enroll       = "OPTIONAL"
  }
}
