#!/usr/bin/env python3
"""
import_oig_resources.py

Automatically import existing OIG resources from Okta into Terraform.

This script:
1. Queries Okta API for existing OIG resources (entitlements, reviews, etc.)
2. Generates Terraform configuration files (.tf)
3. Generates terraform import commands

Usage:
    python3 scripts/import_oig_resources.py --output-dir imported_oig

Environment variables required:
    OKTA_ORG_NAME - Your Okta org name
    OKTA_API_TOKEN - API token with governance scopes
    OKTA_BASE_URL - Base URL (default: okta.com)
"""

import argparse
import json
import os
import sys
import requests
from typing import List, Dict, Optional
import re


class OIGImporter:
    """Import existing OIG resources from Okta"""

    def __init__(self, org_name: str, base_url: str, api_token: str):
        self.org_name = org_name
        self.base_url = f"https://{org_name}.{base_url}"
        self.headers = {
            "Authorization": f"SSWS {api_token}",
            "Content-Type": "application/json",
            "Accept": "application/json"
        }
        self.session = requests.Session()
        self.session.headers.update(self.headers)

    def _make_request(self, method: str, url: str, **kwargs) -> requests.Response:
        """Make API request with error handling"""
        try:
            response = self.session.request(method, url, **kwargs)
            response.raise_for_status()
            return response
        except requests.exceptions.RequestException as e:
            print(f"API request failed: {e}")
            if hasattr(e.response, 'text'):
                print(f"Response: {e.response.text}")
            raise

    def _sanitize_name(self, name: str) -> str:
        """Convert name to valid Terraform resource name"""
        # Remove special characters, convert to lowercase, replace spaces with underscores
        sanitized = re.sub(r'[^a-zA-Z0-9_]', '_', name.lower())
        # Remove consecutive underscores
        sanitized = re.sub(r'_+', '_', sanitized)
        # Remove leading/trailing underscores
        sanitized = sanitized.strip('_')
        # Ensure it doesn't start with a number
        if sanitized and sanitized[0].isdigit():
            sanitized = f"resource_{sanitized}"
        return sanitized or "unnamed"

    def fetch_entitlements(self) -> List[Dict]:
        """Fetch all entitlement bundles from Okta"""
        print("Fetching entitlement bundles...")
        try:
            # Use the correct entitlement-bundles endpoint
            url = f"{self.base_url}/governance/api/v1/entitlement-bundles"
            params = {"limit": 200}
            response = self._make_request("GET", url, params=params)

            # Handle both dict and list responses
            data = response.json()
            if isinstance(data, list):
                bundles = data
            elif isinstance(data, dict):
                bundles = data.get("data", data.get("entitlements", []))
            else:
                bundles = []

            print(f"  Found {len(bundles)} entitlement bundles")
            return bundles
        except Exception as e:
            print(f"  ⚠️  Could not fetch entitlement bundles: {e}")
            return []

    def fetch_grants_for_bundle(self, bundle_id: str, target_id: str, target_type: str) -> List[Dict]:
        """Fetch grants (principal assignments) for a specific entitlement bundle

        Args:
            bundle_id: The entitlement bundle ID
            target_id: The target resource ID (e.g., app ID)
            target_type: The target resource type (e.g., "APPLICATION")
        """
        try:
            url = f"{self.base_url}/governance/api/v1/grants"
            # Filter grants by target resource (required by API)
            # API requires filtering by resource, not by entitlement directly
            filter_expr = f'target.externalId eq "{target_id}" AND target.type eq "{target_type}"'
            params = {"filter": filter_expr, "limit": 200, "include": "full_entitlements"}
            response = self._make_request("GET", url, params=params)

            data = response.json()
            if isinstance(data, list):
                all_grants = data
            elif isinstance(data, dict):
                all_grants = data.get("data", data.get("grants", []))
            else:
                all_grants = []

            # Filter client-side for grants matching this specific entitlement bundle
            matching_grants = []
            print(f"      DEBUG: Received {len(all_grants)} total grants for target {target_id}")
            for grant in all_grants:
                # Check if grant's entitlement matches our bundle
                entitlement = grant.get("entitlement", {})
                entitlement_id = entitlement.get("id") or entitlement.get("externalId")
                print(f"      DEBUG: Grant entitlement ID: {entitlement_id}, looking for: {bundle_id}")
                if entitlement_id == bundle_id:
                    matching_grants.append(grant)
                    print(f"      DEBUG: ✓ Match found!")

            print(f"      DEBUG: Found {len(matching_grants)} matching grants")
            return matching_grants
        except Exception as e:
            print(f"    ⚠️  Could not fetch grants for bundle {bundle_id}: {e}")
            return []

    def fetch_reviews(self) -> List[Dict]:
        """Fetch all access review campaigns"""
        print("Fetching access review campaigns...")
        try:
            url = f"{self.base_url}/governance/api/v1/reviews"
            params = {"limit": 200}
            response = self._make_request("GET", url, params=params)
            reviews = response.json().get("data", [])
            print(f"  Found {len(reviews)} review campaigns")
            return reviews
        except Exception as e:
            print(f"  ⚠️  Could not fetch reviews: {e}")
            return []

    def fetch_request_sequences(self) -> List[Dict]:
        """Fetch all approval workflows"""
        print("Fetching approval workflows...")
        try:
            url = f"{self.base_url}/governance/api/v1/request-sequences"
            params = {"limit": 200}
            response = self._make_request("GET", url, params=params)
            sequences = response.json().get("data", [])
            print(f"  Found {len(sequences)} approval workflows")
            return sequences
        except Exception as e:
            print(f"  ⚠️  Could not fetch request sequences: {e}")
            return []

    def fetch_catalog_entries(self) -> List[Dict]:
        """Fetch all catalog entries"""
        print("Fetching catalog entries...")
        try:
            url = f"{self.base_url}/governance/api/v1/catalog/entries"
            params = {"limit": 200}
            response = self._make_request("GET", url, params=params)
            entries = response.json().get("data", [])
            print(f"  Found {len(entries)} catalog entries")
            return entries
        except Exception as e:
            print(f"  ⚠️  Could not fetch catalog entries: {e}")
            return []

    def fetch_request_settings(self) -> Optional[Dict]:
        """Fetch global request settings"""
        print("Fetching request settings...")
        try:
            url = f"{self.base_url}/governance/api/v1/request-settings"
            response = self._make_request("GET", url)
            settings = response.json()
            print(f"  Found request settings")
            return settings
        except Exception as e:
            print(f"  ⚠️  Could not fetch request settings: {e}")
            return None

    def generate_entitlement_tf(self, bundles: List[Dict]) -> tuple[str, List[str]]:
        """Generate Terraform config and import commands for entitlement bundles"""
        if not bundles:
            return "", []

        tf_config = []
        import_commands = []

        tf_config.append("# =============================================================================")
        tf_config.append("# OKTA IDENTITY GOVERNANCE - ENTITLEMENT BUNDLES")
        tf_config.append("# =============================================================================")
        tf_config.append("# These are entitlement bundles imported from Okta.")
        tf_config.append("# Each bundle represents a collection of access rights.")
        tf_config.append("#")
        tf_config.append("# NOTE: The Terraform okta_principal_entitlements resource is used to manage")
        tf_config.append("# assignments of principals to entitlements. The bundles themselves are")
        tf_config.append("# managed via the API and cannot be created in Terraform.")
        tf_config.append("#")
        tf_config.append("# To import: Run the generated import.sh script")
        tf_config.append("# =============================================================================")
        tf_config.append("")

        for bundle in bundles:
            bundle_id = bundle.get("id") or bundle.get("bundleId")
            name = bundle.get("name", "unnamed")
            description = bundle.get("description", "")
            orn = bundle.get("orn", "")
            bundle_type = bundle.get("bundleType", "MANUAL")

            # Skip app-managed bundles if they shouldn't be in Terraform
            if ":apps:" in orn and bundle_type != "MANUAL":
                print(f"  Skipping app-managed bundle: {name}")
                continue

            safe_name = self._sanitize_name(name)

            # Extract target resource information for grants query
            target = bundle.get("target", {})
            target_id = target.get("externalId", "")
            target_type = target.get("type", "")

            # Fetch grants (principal assignments) for this bundle
            if target_id and target_type:
                print(f"  Fetching grants for: {name}")
                grants = self.fetch_grants_for_bundle(bundle_id, target_id, target_type)
            else:
                print(f"  ⚠️  No target resource found for: {name}, skipping grants")
                grants = []

            tf_config.append(f'# {"-" * 77}')
            tf_config.append(f'# {name}')
            tf_config.append(f'# {"-" * 77}')
            tf_config.append(f'')
            tf_config.append(f'resource "okta_principal_entitlements" "{safe_name}" {{')
            tf_config.append(f'  # Bundle ID: {bundle_id}')
            tf_config.append(f'  # ORN: {orn}')
            tf_config.append(f'  # Type: {bundle_type}')
            if description:
                tf_config.append(f'  # Description: {description}')
            tf_config.append(f'')

            # Generate principal blocks from grants
            if grants:
                print(f"    Found {len(grants)} grant(s)")
                for grant in grants:
                    # Try nested structure first (targetPrincipal.externalId)
                    # then fall back to direct fields (principalId)
                    target_principal = grant.get("targetPrincipal", {})
                    principal_id = target_principal.get("externalId") or grant.get("principalId")
                    principal_type = target_principal.get("type", "").replace("OKTA_", "") or grant.get("principalType", "USER")
                    principal_name = target_principal.get("name") or grant.get("principalName", "")

                    if principal_id:
                        tf_config.append(f'  principal {{')
                        tf_config.append(f'    id   = "{principal_id}"')
                        tf_config.append(f'    type = "{principal_type}"')
                        if principal_name:
                            tf_config.append(f'    # Name: {principal_name}')
                        tf_config.append(f'  }}')
                        tf_config.append(f'')

                # Add entitlement block
                tf_config.append(f'  entitlement {{')
                tf_config.append(f'    id   = "{bundle_id}"')
                tf_config.append(f'    name = "{name}"')
                tf_config.append(f'  }}')
            else:
                # No grants found - add TODO comment
                tf_config.append(f'  # TODO: No principal assignments found')
                tf_config.append(f'  # Add principal and entitlement configuration as needed')
                tf_config.append(f'')
                tf_config.append(f'  # Example configuration:')
                tf_config.append(f'  # principal {{')
                tf_config.append(f'  #   id   = "00u..."  # User or group ID')
                tf_config.append(f'  #   type = "USER"    # or "GROUP"')
                tf_config.append(f'  # }}')
                tf_config.append(f'  #')
                tf_config.append(f'  # entitlement {{')
                tf_config.append(f'  #   id   = "{bundle_id}"')
                tf_config.append(f'  #   name = "{name}"')
                tf_config.append(f'  # }}')

            tf_config.append(f'}}')
            tf_config.append('')

            # For import, we may need the bundle ID or a different identifier
            # This might need adjustment based on actual Terraform import syntax
            import_commands.append(f'# Import bundle: {name}')
            import_commands.append(f'# terraform import okta_principal_entitlements.{safe_name} {bundle_id}')
            import_commands.append('')

        return "\n".join(tf_config), import_commands

    def generate_reviews_tf(self, reviews: List[Dict]) -> tuple[str, List[str]]:
        """Generate Terraform config and import commands for access reviews"""
        if not reviews:
            return "", []

        tf_config = []
        import_commands = []

        tf_config.append("# Access Review Campaigns\n")

        for review in reviews:
            review_id = review.get("id")
            name = review.get("name", "unnamed")
            description = review.get("description", "")
            safe_name = self._sanitize_name(name)

            tf_config.append(f'resource "okta_reviews" "{safe_name}" {{')
            tf_config.append(f'  # ID: {review_id}')
            tf_config.append(f'  name        = "{name}"')
            if description:
                tf_config.append(f'  description = "{description}"')
            tf_config.append(f'')
            tf_config.append(f'  # TODO: Add schedule, scope, and reviewer configuration')
            tf_config.append(f'  # See: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/reviews')
            tf_config.append(f'}}')
            tf_config.append('')

            import_commands.append(f'terraform import okta_reviews.{safe_name} {review_id}')

        return "\n".join(tf_config), import_commands

    def generate_request_sequences_tf(self, sequences: List[Dict]) -> tuple[str, List[str]]:
        """Generate Terraform config and import commands for approval workflows"""
        if not sequences:
            return "", []

        tf_config = []
        import_commands = []

        tf_config.append("# Approval Workflows (Request Sequences)\n")

        for seq in sequences:
            seq_id = seq.get("id")
            name = seq.get("name", "unnamed")
            description = seq.get("description", "")
            safe_name = self._sanitize_name(name)

            tf_config.append(f'resource "okta_request_sequences" "{safe_name}" {{')
            tf_config.append(f'  # ID: {seq_id}')
            tf_config.append(f'  name        = "{name}"')
            if description:
                tf_config.append(f'  description = "{description}"')
            tf_config.append(f'')
            tf_config.append(f'  # TODO: Add approval stages')
            tf_config.append(f'  # See: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/request_sequences')
            tf_config.append(f'}}')
            tf_config.append('')

            import_commands.append(f'terraform import okta_request_sequences.{safe_name} {seq_id}')

        return "\n".join(tf_config), import_commands

    def generate_catalog_entries_tf(self, entries: List[Dict]) -> tuple[str, List[str]]:
        """Generate Terraform config and import commands for catalog entries"""
        if not entries:
            return "", []

        tf_config = []
        import_commands = []

        tf_config.append("# Catalog Entries\n")

        for entry in entries:
            entry_id = entry.get("id")
            app_id = entry.get("appId")
            name = entry.get("name", "unnamed")
            safe_name = self._sanitize_name(name)

            tf_config.append(f'resource "okta_catalog_entry_default" "{safe_name}" {{')
            tf_config.append(f'  # ID: {entry_id}')
            tf_config.append(f'  app_id = "{app_id}"')
            tf_config.append(f'')
            tf_config.append(f'  # TODO: Review and add catalog configuration')
            tf_config.append(f'  # See: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/catalog_entry_default')
            tf_config.append(f'}}')
            tf_config.append('')

            import_commands.append(f'terraform import okta_catalog_entry_default.{safe_name} {entry_id}')

        return "\n".join(tf_config), import_commands

    def generate_request_settings_tf(self, settings: Optional[Dict]) -> tuple[str, List[str]]:
        """Generate Terraform config and import commands for request settings"""
        if not settings:
            return "", []

        tf_config = []
        import_commands = []

        tf_config.append("# Global Request Settings\n")
        tf_config.append('resource "okta_request_settings" "settings" {')
        tf_config.append('  # Global settings for access requests')
        tf_config.append('')
        tf_config.append('  # TODO: Add request settings configuration')
        tf_config.append('  # See: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/request_settings')
        tf_config.append('}')
        tf_config.append('')

        import_commands.append('terraform import okta_request_settings.settings default')

        return "\n".join(tf_config), import_commands

    def export_json(self, output_file: str, data: Dict):
        """Export raw API data to JSON for reference"""
        with open(output_file, 'w') as f:
            json.dump(data, f, indent=2)
        print(f"  Exported JSON to: {output_file}")

    def generate_import_files(self, output_dir: str):
        """Generate all Terraform files and import commands"""
        print(f"\n{'='*60}")
        print(f"Importing OIG Resources from Okta")
        print(f"{'='*60}\n")

        # Create output directory
        os.makedirs(output_dir, exist_ok=True)

        # Fetch all resources
        entitlements = self.fetch_entitlements()
        reviews = self.fetch_reviews()
        sequences = self.fetch_request_sequences()
        catalog_entries = self.fetch_catalog_entries()
        request_settings = self.fetch_request_settings()

        print(f"\n{'='*60}")
        print(f"Generating Terraform Configurations")
        print(f"{'='*60}\n")

        all_import_commands = []

        # Generate entitlements
        if entitlements:
            print("Generating entitlements configuration...")
            tf_content, imports = self.generate_entitlement_tf(entitlements)
            if tf_content:
                tf_file = os.path.join(output_dir, "entitlements.tf")
                with open(tf_file, 'w') as f:
                    f.write(tf_content)
                print(f"  Created: {tf_file}")
                all_import_commands.extend(imports)

            # Export raw JSON for reference
            json_file = os.path.join(output_dir, "entitlements.json")
            self.export_json(json_file, {"entitlements": entitlements})

        # Generate reviews
        if reviews:
            print("Generating access reviews configuration...")
            tf_content, imports = self.generate_reviews_tf(reviews)
            if tf_content:
                tf_file = os.path.join(output_dir, "reviews.tf")
                with open(tf_file, 'w') as f:
                    f.write(tf_content)
                print(f"  Created: {tf_file}")
                all_import_commands.extend(imports)

            json_file = os.path.join(output_dir, "reviews.json")
            self.export_json(json_file, {"reviews": reviews})

        # Generate request sequences
        if sequences:
            print("Generating approval workflows configuration...")
            tf_content, imports = self.generate_request_sequences_tf(sequences)
            if tf_content:
                tf_file = os.path.join(output_dir, "request_sequences.tf")
                with open(tf_file, 'w') as f:
                    f.write(tf_content)
                print(f"  Created: {tf_file}")
                all_import_commands.extend(imports)

            json_file = os.path.join(output_dir, "request_sequences.json")
            self.export_json(json_file, {"sequences": sequences})

        # Generate catalog entries
        if catalog_entries:
            print("Generating catalog entries configuration...")
            tf_content, imports = self.generate_catalog_entries_tf(catalog_entries)
            if tf_content:
                tf_file = os.path.join(output_dir, "catalog_entries.tf")
                with open(tf_file, 'w') as f:
                    f.write(tf_content)
                print(f"  Created: {tf_file}")
                all_import_commands.extend(imports)

            json_file = os.path.join(output_dir, "catalog_entries.json")
            self.export_json(json_file, {"catalog_entries": catalog_entries})

        # Generate request settings
        if request_settings:
            print("Generating request settings configuration...")
            tf_content, imports = self.generate_request_settings_tf(request_settings)
            if tf_content:
                tf_file = os.path.join(output_dir, "request_settings.tf")
                with open(tf_file, 'w') as f:
                    f.write(tf_content)
                print(f"  Created: {tf_file}")
                all_import_commands.extend(imports)

            json_file = os.path.join(output_dir, "request_settings.json")
            self.export_json(json_file, {"request_settings": request_settings})

        # Generate import script
        if all_import_commands:
            print("\nGenerating import script...")
            import_script = os.path.join(output_dir, "import.sh")
            with open(import_script, 'w') as f:
                f.write("#!/bin/bash\n")
                f.write("# Terraform import commands for OIG resources\n")
                f.write("# Review the generated .tf files and complete TODO items before running\n\n")
                f.write("set -e\n\n")
                for cmd in all_import_commands:
                    f.write(f"{cmd}\n")

            os.chmod(import_script, 0o755)
            print(f"  Created: {import_script}")

        print(f"\n{'='*60}")
        print(f"Import Generation Complete!")
        print(f"{'='*60}\n")
        print(f"Generated files in: {output_dir}/")
        print(f"")
        print(f"Next steps:")
        print(f"1. Review the generated .tf files in {output_dir}/")
        print(f"2. Complete TODO items in each file")
        print(f"3. Copy files to your Terraform directory")
        print(f"4. Run: cd {output_dir} && terraform init")
        print(f"5. Run: ./import.sh")
        print(f"6. Verify: terraform plan (should show no changes)")
        print(f"")
        print(f"Note: .json files contain raw API data for reference")
        print(f"{'='*60}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Import existing OIG resources from Okta into Terraform"
    )
    parser.add_argument(
        "--output-dir",
        default="imported_oig",
        help="Output directory for generated Terraform files"
    )
    parser.add_argument(
        "--org-name",
        help="Okta organization name (or set OKTA_ORG_NAME env var)"
    )
    parser.add_argument(
        "--base-url",
        default=None,
        help="Okta base URL (default: okta.com, or OKTA_BASE_URL env var)"
    )
    parser.add_argument(
        "--api-token",
        help="Okta API token (or set OKTA_API_TOKEN env var)"
    )

    args = parser.parse_args()

    # Get credentials
    org_name = args.org_name or os.environ.get("OKTA_ORG_NAME")
    api_token = args.api_token or os.environ.get("OKTA_API_TOKEN")
    base_url = args.base_url or os.environ.get("OKTA_BASE_URL", "okta.com")

    if not org_name or not api_token:
        print("Error: Okta org name and API token required")
        print("Set via --org-name and --api-token or OKTA_ORG_NAME and OKTA_API_TOKEN env vars")
        sys.exit(1)

    # Run import
    importer = OIGImporter(org_name, base_url, api_token)
    importer.generate_import_files(args.output_dir)


if __name__ == "__main__":
    main()
