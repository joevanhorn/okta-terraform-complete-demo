# =============================================================================
# OKTA IDENTITY GOVERNANCE - ENTITLEMENT BUNDLES
# =============================================================================
# Entitlement bundles define collections of access rights that can be assigned
# to users and groups. These bundles are managed via Terraform.
#
# IMPORTANT:
# - Entitlement BUNDLES (definitions) are managed here in Terraform
# - Entitlement ASSIGNMENTS (which users/groups have bundles) should be
#   managed in Okta Admin UI or via direct API calls, NOT in Terraform
#
# Resource: okta_entitlement_bundle
# Documentation: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/entitlement_bundle
# =============================================================================

# -----------------------------------------------------------------------------
# Datadog Read Only
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "datadog_read_only" {
  name                = "Datadog Read Only"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12zbvfgMan9Qak1d7"
  status              = "ACTIVE"

  target {
    external_id = "0oanitkncxGbbNwrl1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "esp12zbv44vDNoeIU1d7"
    values {
      id = "ent12zbv46MO7EWrw1d7"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12zbvfgMan9Qak1d7
}

# -----------------------------------------------------------------------------
# Datadog Standard
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "datadog_standard" {
  name                = "Datadog Standard"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12zbvfc1Rwq0uN1d7"
  status              = "ACTIVE"

  target {
    external_id = "0oanitkncxGbbNwrl1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "esp12zbv44vDNoeIU1d7"
    values {
      id = "ent12zbv45QDKnhaM1d7"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12zbvfc1Rwq0uN1d7
}

# -----------------------------------------------------------------------------
# Datadog Admin ROle
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "datadog_admin_role" {
  name                = "Datadog Admin ROle"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12zcvwl8qvb6Xv1d7"
  status              = "ACTIVE"

  target {
    external_id = "0oanitkncxGbbNwrl1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "esp12zbv44vDNoeIU1d7"
    values {
      id = "ent12zbv47bjSFrHZ1d7"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12zcvwl8qvb6Xv1d7
}

# -----------------------------------------------------------------------------
# Request Report of My Company's Users
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "request_report_of_my_company_s_users" {
  name                = "Request Report of My Company's Users"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12x0qhaHpOxq6C1d7"
  status              = "ACTIVE"

  target {
    external_id = "0oar6jgx89kx2xO9I1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "esp12x0qh8DjqIauW1d7"
    values {
      id = "ent12x0qh9idQPGKM1d7"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12x0qhaHpOxq6C1d7
}

# -----------------------------------------------------------------------------
# Developer Bundle
# Bundle of base access for developers
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "developer_bundle" {
  name                = "Developer Bundle"
  description         = "Bundle of base access for developers"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12pob86e9ExVBm1d7"
  status              = "ACTIVE"

  target {
    external_id = "0oar0edy8iuBrRn6t1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "esp12pvbc9GsRkvu31d7"
    values {
      id = "ent12pvea9ScwnaQX1d7"
    }
    values {
      id = "ent12pvebn5KdeN9l1d7"
    }
    values {
      id = "ent12pvegiIQf9qti1d7"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12pob86e9ExVBm1d7
}

# -----------------------------------------------------------------------------
# Asset Administrator
# For asset management team
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "asset_administrator" {
  name                = "Asset Administrator"
  description         = "For asset management team"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12pob80LpIChdk1d7"
  status              = "ACTIVE"

  target {
    external_id = "0oar0edy8iuBrRn6t1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "esp12pvbc9GsRkvu31d7"
    values {
      id = "ent12pva5mRfBHowQ1d7"
    }
    values {
      id = "ent12pve7wUvKWXVS1d7"
    }
    values {
      id = "ent12pve87e6OIyjW1d7"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12pob80LpIChdk1d7
}

# -----------------------------------------------------------------------------
# IT Service Desk - Agent Bundle
# Standard access bundle for L1 and L2 service desk agents
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "it_service_desk_agent_bundle" {
  name                = "IT Service Desk - Agent Bundle"
  description         = "Standard access bundle for L1 and L2 service desk agents"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12pmq4gjryR0E31d7"
  status              = "ACTIVE"

  target {
    external_id = "0oar0edy8iuBrRn6t1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "esp12pvbc9GsRkvu31d7"
    values {
      id = "ent12pve80mQeNNUE1d7"
    }
    values {
      id = "ent12pve87e6OIyjW1d7"
    }
    values {
      id = "ent12pve8cHjmlJEW1d7"
    }
    values {
      id = "ent12pveb2wubuGuS1d7"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12pmq4gjryR0E31d7
}

# -----------------------------------------------------------------------------
# B2B Marketing Role
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "b2b_marketing_role" {
  name                = "B2B Marketing Role"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb10ufnbov67EfIn1d7"
  status              = "ACTIVE"

  target {
    external_id = "0oamxiwg4zsrWaeJF1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybuyfg0aY1Xp7y1d6"
    values {
      id = "entybuze9GDQYdAue1d6"
    }
  }

  entitlements {
    id = "espybuyfdDblx1vFd1d6"
    values {
      id = "entybuyhst5EWQmye1d6"
    }
  }

  entitlements {
    id = "espybuyfet4uKnC9j1d6"
    values {
      id = "entybuyiy7YcVRIVB1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb10ufnbov67EfIn1d7
}

# -----------------------------------------------------------------------------
# Example Bundle
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "example_bundle" {
  name                = "Example Bundle"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb10nq3zlAGkuY4F1d7"
  status              = "ACTIVE"

  target {
    external_id = "0oapes0i16fD1dIqu1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "esp10no31j3Qyp2vJ1d7"
    values {
      id = "ent10no31kYItsx3H1d7"
    }
  }

  entitlements {
    id = "esp10np3liBs4F7Mr1d7"
    values {
      id = "ent10np3lj0UX475t1d7"
    }
  }

  entitlements {
    id = "esp10nq3zhKTqUePo1d7"
    values {
      id = "ent10nq3zi7lhGXni1d7"
    }
  }

  entitlements {
    id = "esp10no31lHmsDMl91d7"
    values {
      id = "ent10no31mow95e7F1d7"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb10nq3zlAGkuY4F1d7
}

# -----------------------------------------------------------------------------
# Customer Trial Finance
# Allows management and processing of payments for paid customer trials. 
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "customer_trial_finance" {
  name                = "Customer Trial Finance"
  description         = "Allows management and processing of payments for paid customer trials. "
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbywatjlhTpz7SPd1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamxc34dudXXjGJT1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espyirusl3g5Acmjb1d6"
    values {
      id = "entyirusmOPUhfmLX1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbywatjlhTpz7SPd1d6
}

# -----------------------------------------------------------------------------
# Customer Content Management
# Access to create and manage content used for customer trials on the Salesday platform. 
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "customer_content_management" {
  name                = "Customer Content Management"
  description         = "Access to create and manage content used for customer trials on the Salesday platform. "
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbywatjaevWrlrOJ1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamxc34dudXXjGJT1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espyirusl3g5Acmjb1d6"
    values {
      id = "entyiruspbqDy6iV11d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbywatjaevWrlrOJ1d6
}

# -----------------------------------------------------------------------------
# Sales Associate
# Access roles often required for Sales Associates to complete work around customer trials
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "sales_associate" {
  name                = "Sales Associate"
  description         = "Access roles often required for Sales Associates to complete work around customer trials"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbywatj5ljTAfV0O1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamxc34dudXXjGJT1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espyirusl3g5Acmjb1d6"
    values {
      id = "entyiruso5elEOEg61d6"
    }
    values {
      id = "entyirusnLsvvibvg1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbywatj5ljTAfV0O1d6
}

# -----------------------------------------------------------------------------
# Accounts Payable
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "accounts_payable" {
  name                = "Accounts Payable"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbylme70lOECK1um1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamxbw5sdvxDgPry1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espygyvcjwIY1awIQ1d6"
    values {
      id = "entygyvclarzLpS4C1d6"
    }
  }

  entitlements {
    id = "espyln2a6CE8GxcYz1d6"
    values {
      id = "entyln2a8p6ICgLb11d6"
    }
    values {
      id = "entylme882grbyL6X1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbylme70lOECK1um1d6
}

# -----------------------------------------------------------------------------
# Auditor
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "auditor" {
  name                = "Auditor"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbylme7xWqTdKIbB1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamxbw5sdvxDgPry1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espygyvcjwIY1awIQ1d6"
    values {
      id = "entygyvcmcMj1n27a1d6"
    }
  }

  entitlements {
    id = "espyln2a6CE8GxcYz1d6"
    values {
      id = "entyln2a79ccyUEcG1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbylme7xWqTdKIbB1d6
}

# -----------------------------------------------------------------------------
# Purchasing
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "purchasing" {
  name                = "Purchasing"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbyln29kDyuJ581F1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamxbw5sdvxDgPry1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espygyvcjwIY1awIQ1d6"
    values {
      id = "entygyvclarzLpS4C1d6"
    }
  }

  entitlements {
    id = "espyln2a6CE8GxcYz1d6"
    values {
      id = "entyln2a9rCVBtG9c1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbyln29kDyuJ581F1d6
}

# -----------------------------------------------------------------------------
# Realm Auditor
# Use this request to get access to audit and report on all realms.
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "realm_auditor" {
  name                = "Realm Auditor"
  description         = "Use this request to get access to audit and report on all realms."
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbyce61eyAdMLeRa1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamz8tk2nj4bZnbI1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espyce5bbgNyEsRN41d6"
    values {
      id = "entyce5bcOM2DDBEE1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbyce61eyAdMLeRa1d6
}

# -----------------------------------------------------------------------------
# Realm Admin
# Use this request to have a new Realm created and to be made an administrator of it. 
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "realm_admin" {
  name                = "Realm Admin"
  description         = "Use this request to have a new Realm created and to be made an administrator of it. "
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbyce5beI4h4ZpiL1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamz8tk2nj4bZnbI1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espyce5bbgNyEsRN41d6"
    values {
      id = "entyce5bdBAWSYVEI1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbyce5beI4h4ZpiL1d6
}

# -----------------------------------------------------------------------------
# Group Administrator
# Group Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "group_administrator" {
  name                = "Group Administrator"
  description         = "Group Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr791zEltKnNM1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybtgrrAolZ6Eso1d6"
    values {
      id = "entybtgrsSrMJeC0Z1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr791zEltKnNM1d6
}

# -----------------------------------------------------------------------------
# Super Organization Administrator
# Super Organization Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "super_organization_administrator" {
  name                = "Super Organization Administrator"
  description         = "Super Organization Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2jiPAyBUe3T1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybr744xrP7dmkR1d6"
    values {
      id = "entybr745vozq71kV1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2jiPAyBUe3T1d6
}

# -----------------------------------------------------------------------------
# Report Administrator
# Report Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "report_administrator" {
  name                = "Report Administrator"
  description         = "Report Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr78nCPHASTg51d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybtgroSK946jxq1d6"
    values {
      id = "entybtgrpNrPlwdTY1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr78nCPHASTg51d6
}

# -----------------------------------------------------------------------------
# Read-only Administrator
# Read-only Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "read_only_administrator" {
  name                = "Read-only Administrator"
  description         = "Read-only Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2jeB4KymizN1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybtgrmNtQjGYvk1d6"
    values {
      id = "entybtgrn9s7Ufon01d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2jeB4KymizN1d6
}

# -----------------------------------------------------------------------------
# Organization Administrator
# Organization Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "organization_administrator" {
  name                = "Organization Administrator"
  description         = "Organization Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2javo5dcN4G1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybtgrkgpbCQHUS1d6"
    values {
      id = "entybtgrlv0lYy73V1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2javo5dcN4G1d6
}

# -----------------------------------------------------------------------------
# Mobile Administrator
# Mobile Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "mobile_administrator" {
  name                = "Mobile Administrator"
  description         = "Mobile Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2j6FAUy9Jis1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybr78fFzzsN2vY1d6"
    values {
      id = "entybr78gEY9YiWAt1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2j6FAUy9Jis1d6
}

# -----------------------------------------------------------------------------
# Help Desk Administrator
# Help Desk Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "help_desk_administrator" {
  name                = "Help Desk Administrator"
  description         = "Help Desk Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2j2WdriUP8L1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybr78dOCeE0xWA1d6"
    values {
      id = "entybr78eMZ0ZsyyH1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2j2WdriUP8L1d6
}

# -----------------------------------------------------------------------------
# Group Membership Administrator
# Group Membership Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "group_membership_administrator" {
  name                = "Group Membership Administrator"
  description         = "Group Membership Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr74kotubjqR01d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybt2j0NL4YdGV91d6"
    values {
      id = "entybt2j1r6vhn8FF1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr74kotubjqR01d6
}

# -----------------------------------------------------------------------------
# Application Administrator
# Application Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "application_administrator" {
  name                = "Application Administrator"
  description         = "Application Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2iwvQtKgHK51d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybr788bN8NoA151d6"
    values {
      id = "entybr789g9k5BuWe1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2iwvQtKgHK51d6
}

# -----------------------------------------------------------------------------
# API Access Management Administrator
# API Access Management Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "api_access_management_administrator" {
  name                = "API Access Management Administrator"
  description         = "API Access Management Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr7845qDAUdXb1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybr74iuWJlkmCm1d6"
    values {
      id = "entybr74jTHs020JN1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr7845qDAUdXb1d6
}

# -----------------------------------------------------------------------------
# Workflows Administrator
# Workflows Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "workflows_administrator" {
  name                = "Workflows Administrator"
  description         = "Workflows Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr74ehIJFA41L1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybr782AbfntU8S1d6"
    values {
      id = "entybr783h32lyYrZ1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr74ehIJFA41L1d6
}

# -----------------------------------------------------------------------------
# Access Requests Administrator
# Access Requests Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "access_requests_administrator" {
  name                = "Access Requests Administrator"
  description         = "Access Requests Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr74ap1j9m6Qc1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybt2irxr3i50NN1d6"
    values {
      id = "entybt2islYE7JXGn1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr74ap1j9m6Qc1d6
}

# -----------------------------------------------------------------------------
# Access Certifications Administrator
# Access Certifications Administrator
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "access_certifications_administrator" {
  name                = "Access Certifications Administrator"
  description         = "Access Certifications Administrator"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr746NrVQrM1E1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamx5xxhoWmuxbt61d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybt2ipTOQhIZoz1d6"
    values {
      id = "entybt2iqhRJCiD9f1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr746NrVQrM1E1d6
}

# -----------------------------------------------------------------------------
# Salesforce Access
# -----------------------------------------------------------------------------

resource "okta_entitlement_bundle" "salesforce_access" {
  name                = "Salesforce Access"
  target_resource_orn = "orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr73q6YWsfFeC1d6"
  status              = "ACTIVE"

  target {
    external_id = "0oamxiwg4zsrWaeJF1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "espybuyfet4uKnC9j1d6"
    values {
      id = "entybuyibwGtDw8pH1d6"
    }
  }

  # Bundle Type: MANUAL
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr73q6YWsfFeC1d6
}
