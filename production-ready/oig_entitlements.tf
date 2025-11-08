# =============================================================================
# OKTA IDENTITY GOVERNANCE - ENTITLEMENT BUNDLES
# =============================================================================
# These are entitlement bundles imported from Okta.
# Each bundle represents a collection of access rights.
#
# NOTE: The Terraform okta_principal_entitlements resource is used to manage
# assignments of principals to entitlements. The bundles themselves are
# managed via the API and cannot be created in Terraform.
#
# To import: Run the generated import.sh script
# =============================================================================

# -----------------------------------------------------------------------------
# Datadog Read Only
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "datadog_read_only" {
  # Bundle ID: enb12zbvfgMan9Qak1d7
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12zbvfgMan9Qak1d7
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enb12zbvfgMan9Qak1d7"
  #   name = "Datadog Read Only"
  # }
}

# -----------------------------------------------------------------------------
# Datadog Standard
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "datadog_standard" {
  # Bundle ID: enb12zbvfc1Rwq0uN1d7
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12zbvfc1Rwq0uN1d7
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enb12zbvfc1Rwq0uN1d7"
  #   name = "Datadog Standard"
  # }
}

# -----------------------------------------------------------------------------
# Datadog Admin ROle
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "datadog_admin_role" {
  # Bundle ID: enb12zcvwl8qvb6Xv1d7
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12zcvwl8qvb6Xv1d7
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enb12zcvwl8qvb6Xv1d7"
  #   name = "Datadog Admin ROle"
  # }
}

# -----------------------------------------------------------------------------
# Request Report of My Company's Users
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "request_report_of_my_company_s_users" {
  # Bundle ID: enb12x0qhaHpOxq6C1d7
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12x0qhaHpOxq6C1d7
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enb12x0qhaHpOxq6C1d7"
  #   name = "Request Report of My Company's Users"
  # }
}

# -----------------------------------------------------------------------------
# Developer Bundle
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "developer_bundle" {
  # Bundle ID: enb12pob86e9ExVBm1d7
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12pob86e9ExVBm1d7
  # Type: MANUAL
  # Description: Bundle of base access for developers

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enb12pob86e9ExVBm1d7"
  #   name = "Developer Bundle"
  # }
}

# -----------------------------------------------------------------------------
# Asset Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "asset_administrator" {
  # Bundle ID: enb12pob80LpIChdk1d7
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12pob80LpIChdk1d7
  # Type: MANUAL
  # Description: For asset management team

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enb12pob80LpIChdk1d7"
  #   name = "Asset Administrator"
  # }
}

# -----------------------------------------------------------------------------
# IT Service Desk - Agent Bundle
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "it_service_desk_agent_bundle" {
  # Bundle ID: enb12pmq4gjryR0E31d7
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb12pmq4gjryR0E31d7
  # Type: MANUAL
  # Description: Standard access bundle for L1 and L2 service desk agents

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enb12pmq4gjryR0E31d7"
  #   name = "IT Service Desk - Agent Bundle"
  # }
}

# -----------------------------------------------------------------------------
# B2B Marketing Role
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "b2b_marketing_role" {
  # Bundle ID: enb10ufnbov67EfIn1d7
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb10ufnbov67EfIn1d7
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enb10ufnbov67EfIn1d7"
  #   name = "B2B Marketing Role"
  # }
}

# -----------------------------------------------------------------------------
# Example Bundle
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "example_bundle" {
  # Bundle ID: enb10nq3zlAGkuY4F1d7
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enb10nq3zlAGkuY4F1d7
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enb10nq3zlAGkuY4F1d7"
  #   name = "Example Bundle"
  # }
}

# -----------------------------------------------------------------------------
# Customer Trial Finance
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "customer_trial_finance" {
  # Bundle ID: enbywatjlhTpz7SPd1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbywatjlhTpz7SPd1d6
  # Type: MANUAL
  # Description: Allows management and processing of payments for paid customer trials. 

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbywatjlhTpz7SPd1d6"
  #   name = "Customer Trial Finance"
  # }
}

# -----------------------------------------------------------------------------
# Customer Content Management
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "customer_content_management" {
  # Bundle ID: enbywatjaevWrlrOJ1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbywatjaevWrlrOJ1d6
  # Type: MANUAL
  # Description: Access to create and manage content used for customer trials on the Salesday platform. 

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbywatjaevWrlrOJ1d6"
  #   name = "Customer Content Management"
  # }
}

# -----------------------------------------------------------------------------
# Sales Associate
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "sales_associate" {
  # Bundle ID: enbywatj5ljTAfV0O1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbywatj5ljTAfV0O1d6
  # Type: MANUAL
  # Description: Access roles often required for Sales Associates to complete work around customer trials

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbywatj5ljTAfV0O1d6"
  #   name = "Sales Associate"
  # }
}

# -----------------------------------------------------------------------------
# Accounts Payable
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "accounts_payable" {
  # Bundle ID: enbylme70lOECK1um1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbylme70lOECK1um1d6
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbylme70lOECK1um1d6"
  #   name = "Accounts Payable"
  # }
}

# -----------------------------------------------------------------------------
# Auditor
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "auditor" {
  # Bundle ID: enbylme7xWqTdKIbB1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbylme7xWqTdKIbB1d6
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbylme7xWqTdKIbB1d6"
  #   name = "Auditor"
  # }
}

# -----------------------------------------------------------------------------
# Purchasing
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "purchasing" {
  # Bundle ID: enbyln29kDyuJ581F1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbyln29kDyuJ581F1d6
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbyln29kDyuJ581F1d6"
  #   name = "Purchasing"
  # }
}

# -----------------------------------------------------------------------------
# Realm Auditor
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "realm_auditor" {
  # Bundle ID: enbyce61eyAdMLeRa1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbyce61eyAdMLeRa1d6
  # Type: MANUAL
  # Description: Use this request to get access to audit and report on all realms.

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbyce61eyAdMLeRa1d6"
  #   name = "Realm Auditor"
  # }
}

# -----------------------------------------------------------------------------
# Realm Admin
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "realm_admin" {
  # Bundle ID: enbyce5beI4h4ZpiL1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbyce5beI4h4ZpiL1d6
  # Type: MANUAL
  # Description: Use this request to have a new Realm created and to be made an administrator of it. 

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbyce5beI4h4ZpiL1d6"
  #   name = "Realm Admin"
  # }
}

# -----------------------------------------------------------------------------
# Group Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "group_administrator" {
  # Bundle ID: enbybr791zEltKnNM1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr791zEltKnNM1d6
  # Type: MANUAL
  # Description: Group Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybr791zEltKnNM1d6"
  #   name = "Group Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Super Organization Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "super_organization_administrator" {
  # Bundle ID: enbybt2jiPAyBUe3T1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2jiPAyBUe3T1d6
  # Type: MANUAL
  # Description: Super Organization Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybt2jiPAyBUe3T1d6"
  #   name = "Super Organization Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Report Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "report_administrator" {
  # Bundle ID: enbybr78nCPHASTg51d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr78nCPHASTg51d6
  # Type: MANUAL
  # Description: Report Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybr78nCPHASTg51d6"
  #   name = "Report Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Read-only Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "read_only_administrator" {
  # Bundle ID: enbybt2jeB4KymizN1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2jeB4KymizN1d6
  # Type: MANUAL
  # Description: Read-only Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybt2jeB4KymizN1d6"
  #   name = "Read-only Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Organization Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "organization_administrator" {
  # Bundle ID: enbybt2javo5dcN4G1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2javo5dcN4G1d6
  # Type: MANUAL
  # Description: Organization Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybt2javo5dcN4G1d6"
  #   name = "Organization Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Mobile Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "mobile_administrator" {
  # Bundle ID: enbybt2j6FAUy9Jis1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2j6FAUy9Jis1d6
  # Type: MANUAL
  # Description: Mobile Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybt2j6FAUy9Jis1d6"
  #   name = "Mobile Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Help Desk Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "help_desk_administrator" {
  # Bundle ID: enbybt2j2WdriUP8L1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2j2WdriUP8L1d6
  # Type: MANUAL
  # Description: Help Desk Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybt2j2WdriUP8L1d6"
  #   name = "Help Desk Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Group Membership Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "group_membership_administrator" {
  # Bundle ID: enbybr74kotubjqR01d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr74kotubjqR01d6
  # Type: MANUAL
  # Description: Group Membership Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybr74kotubjqR01d6"
  #   name = "Group Membership Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Application Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "application_administrator" {
  # Bundle ID: enbybt2iwvQtKgHK51d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybt2iwvQtKgHK51d6
  # Type: MANUAL
  # Description: Application Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybt2iwvQtKgHK51d6"
  #   name = "Application Administrator"
  # }
}

# -----------------------------------------------------------------------------
# API Access Management Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "api_access_management_administrator" {
  # Bundle ID: enbybr7845qDAUdXb1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr7845qDAUdXb1d6
  # Type: MANUAL
  # Description: API Access Management Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybr7845qDAUdXb1d6"
  #   name = "API Access Management Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Workflows Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "workflows_administrator" {
  # Bundle ID: enbybr74ehIJFA41L1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr74ehIJFA41L1d6
  # Type: MANUAL
  # Description: Workflows Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybr74ehIJFA41L1d6"
  #   name = "Workflows Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Access Requests Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "access_requests_administrator" {
  # Bundle ID: enbybr74ap1j9m6Qc1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr74ap1j9m6Qc1d6
  # Type: MANUAL
  # Description: Access Requests Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybr74ap1j9m6Qc1d6"
  #   name = "Access Requests Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Access Certifications Administrator
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "access_certifications_administrator" {
  # Bundle ID: enbybr746NrVQrM1E1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr746NrVQrM1E1d6
  # Type: MANUAL
  # Description: Access Certifications Administrator

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybr746NrVQrM1E1d6"
  #   name = "Access Certifications Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Salesforce Access
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "salesforce_access" {
  # Bundle ID: enbybr73q6YWsfFeC1d6
  # ORN: orn:okta:governance:00omx5xxhePEbjFNp1d7:entitlement-bundles:enbybr73q6YWsfFeC1d6
  # Type: MANUAL

  # TODO: Add principal assignments
  # This resource type requires principal and entitlement configuration.
  # See the JSON export file for full bundle details.
  # Docs: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/principal_entitlements

  # Example configuration:
  # principal {
  #   id   = "00u..."  # User or group ID
  #   type = "USER"    # or "GROUP"
  # }
  #
  # entitlement {
  #   id   = "enbybr73q6YWsfFeC1d6"
  #   name = "Salesforce Access"
  # }
}
