#!/usr/bin/env python3
"""
sync_label_mappings.py

Syncs label mappings from Okta OIG to the local config/label_mappings.json file.
This keeps the repository's label configuration up-to-date with the Okta environment.

Usage:
    python3 scripts/sync_label_mappings.py
    python3 scripts/sync_label_mappings.py --output config/label_mappings.json
"""

import os
import sys
import json
import requests
import argparse
from typing import Dict, List
from datetime import datetime


class LabelMappingSync:
    """Syncs label mappings from Okta to local config"""

    def __init__(self, org_name: str, base_url: str, api_token: str):
        self.org_name = org_name
        self.base_url = f"https://{org_name}.{base_url}"
        self.governance_base = f"{self.base_url}/governance/api/v1"
        self.headers = {
            "Authorization": f"SSWS {api_token}",
            "Content-Type": "application/json",
            "Accept": "application/json"
        }
        self.session = requests.Session()
        self.session.headers.update(self.headers)

    def get_all_labels(self) -> List[Dict]:
        """Query all labels from Okta"""
        print("Querying labels from Okta...")
        url = f"{self.governance_base}/labels"

        try:
            response = self.session.get(url)
            response.raise_for_status()
            data = response.json()
            labels = data.get("data", [])
            print(f"  ✅ Found {len(labels)} labels")
            return labels
        except Exception as e:
            print(f"  ❌ Error: {e}")
            return []

    def get_all_resource_labels(self) -> List[Dict]:
        """Query all resource-label assignments from Okta"""
        print("Querying resource-label assignments...")
        url = f"{self.governance_base}/resource-labels"
        params = {"limit": 200}

        try:
            response = self.session.get(url, params=params)
            response.raise_for_status()
            data = response.json()
            assignments = data.get("data", [])
            print(f"  ✅ Found {len(assignments)} assignments")
            return assignments
        except Exception as e:
            print(f"  ❌ Error: {e}")
            return []

    def build_mappings(self, labels: List[Dict], assignments: List[Dict]) -> Dict:
        """Build the label mappings structure"""
        print("\nBuilding label mappings...")

        # Build label metadata
        label_metadata = {}
        for label in labels:
            name = label.get("name")
            label_id = label.get("labelId")
            values = label.get("values", [])
            label_value_id = values[0].get("labelValueId") if values else None

            # Extract color from metadata
            color = None
            bg_color = None
            if values:
                metadata = values[0].get("metadata", {})
                additional_props = metadata.get("additionalProperties", {})
                bg_color = additional_props.get("backgroundColor")
                # Map background color to simple color name
                color_map = {
                    "red": "red",
                    "green": "green",
                    "blue": "blue",
                    "orange": "orange",
                    "yellow": "yellow",
                    "purple": "purple"
                }
                color = color_map.get(bg_color, bg_color)

            label_metadata[name] = {
                "labelId": label_id,
                "labelValueId": label_value_id,
                "description": label.get("description", f"{name} label"),
                "color": color,
                "metadata": {
                    "backgroundColor": bg_color
                } if bg_color else {}
            }
            print(f"  • {name}: {label_id} → {label_value_id}")

        # Build assignments by label and resource type
        assignments_by_label = {}
        for assignment in assignments:
            resource = assignment.get("resource", {})
            resource_orn = resource.get("orn", "")
            resource_type = resource.get("type", "")

            # Determine resource category
            if "entitlement-bundles" in resource_orn:
                category = "entitlement_bundles"
            elif ":apps:" in resource_orn:
                category = "apps"
            elif ":groups:" in resource_orn:
                category = "groups"
            else:
                category = "other"

            # Get labels for this resource
            for label in assignment.get("labels", []):
                label_name = label.get("name")

                if label_name not in assignments_by_label:
                    assignments_by_label[label_name] = {
                        "entitlement_bundles": [],
                        "apps": [],
                        "groups": [],
                        "other": []
                    }

                if resource_orn and resource_orn not in assignments_by_label[label_name][category]:
                    assignments_by_label[label_name][category].append(resource_orn)

        print(f"  ✅ Built assignments for {len(assignments_by_label)} labels")

        # Build final structure
        mappings = {
            "description": "Label ID mappings synced from Okta OIG",
            "last_synced": datetime.utcnow().isoformat() + "Z",
            "labels": label_metadata,
            "assignments": {
                "entitlement_bundles": {},
                "apps": {},
                "groups": {},
                "other": {}
            },
            "notes": [
                "This file is the source of truth for label assignments",
                "To add a new label assignment, submit a PR adding the ORN to the appropriate array",
                "Run 'make sync-labels' or the GitHub Actions workflow to apply changes to Okta",
                "Run 'make import-labels' to sync this file from Okta"
            ]
        }

        # Populate assignments
        for label_name in label_metadata.keys():
            for category in ["entitlement_bundles", "apps", "groups", "other"]:
                orns = assignments_by_label.get(label_name, {}).get(category, [])
                mappings["assignments"][category][label_name] = sorted(orns)

        return mappings

    def save_mappings(self, mappings: Dict, output_file: str):
        """Save mappings to file"""
        print(f"\nSaving mappings to {output_file}...")
        with open(output_file, 'w') as f:
            json.dump(mappings, f, indent=2)
        print(f"  ✅ Saved successfully")

    def sync(self, output_file: str) -> bool:
        """Run the complete sync process"""
        print("="*80)
        print("SYNC LABEL MAPPINGS FROM OKTA")
        print("="*80)
        print()

        # Get labels
        labels = self.get_all_labels()
        if not labels:
            print("\n❌ No labels found - cannot sync")
            return False

        # Get assignments
        assignments = self.get_all_resource_labels()

        # Build mappings
        mappings = self.build_mappings(labels, assignments)

        # Save to file
        self.save_mappings(mappings, output_file)

        # Summary
        print("\n" + "="*80)
        print("SYNC SUMMARY")
        print("="*80)
        print(f"  Labels synced: {len(mappings['labels'])}")
        print(f"  Entitlement bundle assignments: {sum(len(orns) for orns in mappings['assignments']['entitlement_bundles'].values())}")
        print(f"  App assignments: {sum(len(orns) for orns in mappings['assignments']['apps'].values())}")
        print(f"  Group assignments: {sum(len(orns) for orns in mappings['assignments']['groups'].values())}")
        print(f"  Output file: {output_file}")
        print("="*80)

        return True


def main():
    parser = argparse.ArgumentParser(
        description="Sync label mappings from Okta to local config"
    )
    parser.add_argument(
        "--org-name",
        default=os.environ.get("OKTA_ORG_NAME"),
        help="Okta organization name"
    )
    parser.add_argument(
        "--base-url",
        default=os.environ.get("OKTA_BASE_URL", "okta.com"),
        help="Okta base URL"
    )
    parser.add_argument(
        "--api-token",
        default=os.environ.get("OKTA_API_TOKEN"),
        help="Okta API token"
    )
    parser.add_argument(
        "--output",
        default="config/label_mappings.json",
        help="Output file path"
    )

    args = parser.parse_args()

    if not args.org_name or not args.api_token:
        print("Error: OKTA_ORG_NAME and OKTA_API_TOKEN must be set")
        sys.exit(1)

    syncer = LabelMappingSync(args.org_name, args.base_url, args.api_token)
    success = syncer.sync(args.output)

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
