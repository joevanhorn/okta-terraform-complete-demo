#!/usr/bin/env python3
"""
okta_api_manager.py

Manages Okta OIG resources not yet available in Terraform provider:
- Resource Owners
- Labels

Usage:
  python okta_api_manager.py --action apply --config terraform_outputs.json
  python okta_api_manager.py --action destroy --config terraform_outputs.json
"""

import argparse
import json
import sys
import requests
from typing import List, Dict, Optional
import time


class OktaAPIManager:
    """Manages Okta OIG resources via REST API"""
    
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
        """Make API request with retry logic"""
        max_retries = 3
        retry_delay = 2
        
        for attempt in range(max_retries):
            try:
                response = self.session.request(method, url, **kwargs)
                
                # Handle rate limiting
                if response.status_code == 429:
                    retry_after = int(response.headers.get('X-Rate-Limit-Reset', time.time() + 60))
                    wait_time = max(retry_after - time.time(), 1)
                    print(f"Rate limited. Waiting {wait_time} seconds...")
                    time.sleep(wait_time)
                    continue
                
                response.raise_for_status()
                return response
                
            except requests.exceptions.RequestException as e:
                if attempt == max_retries - 1:
                    raise
                print(f"Request failed (attempt {attempt + 1}/{max_retries}): {e}")
                time.sleep(retry_delay * (attempt + 1))
        
        raise Exception("Max retries exceeded")
    
    # ==================== Resource Owners ====================
    
    def assign_resource_owners(self, principal_orns: List[str], resource_orns: List[str]) -> Dict:
        """Assign owners to resources"""
        url = f"{self.base_url}/governance/api/v1/resource-owners"
        payload = {
            "principalOrns": principal_orns,
            "resourceOrns": resource_orns
        }
        
        print(f"Assigning {len(principal_orns)} owners to {len(resource_orns)} resources...")
        response = self._make_request("PUT", url, json=payload)
        return response.json()
    
    def list_resource_owners(self, parent_resource_orn: str, include_parent: bool = False) -> Dict:
        """List all resources with assigned owners for a parent resource"""
        url = f"{self.base_url}/governance/api/v1/resource-owners"
        
        # URL encode the filter
        filter_expr = f'parentResourceOrn eq "{parent_resource_orn}"'
        params = {
            "filter": filter_expr,
            "limit": 200
        }
        
        if include_parent:
            params["include"] = "parent_resource_owner"
        
        response = self._make_request("GET", url, params=params)
        return response.json()
    
    def update_resource_owners(self, resource_orn: str, operations: List[Dict]) -> Dict:
        """Update resource owners using PATCH operations"""
        url = f"{self.base_url}/governance/api/v1/resource-owners"
        payload = {
            "resourceOrn": resource_orn,
            "data": operations
        }
        
        response = self._make_request("PATCH", url, json=payload)
        return response.json()
    
    def remove_resource_owner(self, resource_orn: str, principal_orn: str) -> Dict:
        """Remove a specific owner from a resource"""
        operations = [{
            "op": "REMOVE",
            "path": "/principalOrn",
            "value": principal_orn
        }]
        return self.update_resource_owners(resource_orn, operations)
    
    def list_unassigned_resources(self, parent_resource_orn: str, resource_type: Optional[str] = None) -> Dict:
        """List resources without assigned owners"""
        url = f"{self.base_url}/governance/api/v1/resource-owners/catalog/resources"
        
        filter_expr = f'parentResourceOrn eq "{parent_resource_orn}"'
        if resource_type:
            filter_expr += f' AND resource.type eq "{resource_type}"'
        
        params = {
            "filter": filter_expr,
            "limit": 200
        }
        
        response = self._make_request("GET", url, params=params)
        return response.json()
    
    # ==================== Labels ====================
    
    def create_label(self, name: str, description: str = "") -> Dict:
        """Create a governance label"""
        url = f"{self.base_url}/governance/api/v1/labels"
        payload = {
            "name": name,
            "description": description or f"Governance label: {name}"
        }
        
        try:
            response = self._make_request("POST", url, json=payload)
            print(f"Created label: {name}")
            return response.json()
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 409:
                print(f"Label already exists: {name}")
                return {"name": name, "exists": True}
            raise
    
    def list_labels(self) -> Dict:
        """List all governance labels"""
        url = f"{self.base_url}/governance/api/v1/labels"
        params = {"limit": 200}
        
        response = self._make_request("GET", url, params=params)
        return response.json()
    
    def get_label(self, label_name: str) -> Optional[Dict]:
        """Get a specific label by name"""
        url = f"{self.base_url}/governance/api/v1/labels/{label_name}"
        
        try:
            response = self._make_request("GET", url)
            return response.json()
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 404:
                return None
            raise
    
    def apply_labels_to_resources(self, label_name: str, resource_orns: List[str]) -> Dict:
        """Apply a label to one or more resources"""
        url = f"{self.base_url}/governance/api/v1/labels/{label_name}/resources"
        payload = {"resourceOrns": resource_orns}
        
        response = self._make_request("PUT", url, json=payload)
        print(f"Applied label '{label_name}' to {len(resource_orns)} resources")
        return response.json()
    
    def list_resources_by_label(self, label_name: str) -> Dict:
        """List all resources with a specific label"""
        url = f"{self.base_url}/governance/api/v1/labels/{label_name}/resources"
        params = {"limit": 200}
        
        response = self._make_request("GET", url, params=params)
        return response.json()
    
    def remove_label_from_resources(self, label_name: str, resource_orns: List[str]) -> Dict:
        """Remove a label from resources"""
        url = f"{self.base_url}/governance/api/v1/labels/{label_name}/resources"
        payload = {"resourceOrns": resource_orns}
        
        response = self._make_request("DELETE", url, json=payload)
        print(f"Removed label '{label_name}' from {len(resource_orns)} resources")
        return response.json()
    
    # ==================== Helper Methods ====================
    
    def build_user_orn(self, user_id: str) -> str:
        """Build ORN for a user"""
        return f"orn:okta:directory:{self.org_name}:users:{user_id}"
    
    def build_group_orn(self, group_id: str) -> str:
        """Build ORN for a group"""
        return f"orn:okta:directory:{self.org_name}:groups:{group_id}"
    
    def build_app_orn(self, app_id: str, app_type: str = "oauth2") -> str:
        """Build ORN for an application"""
        return f"orn:okta:idp:{self.org_name}:apps:{app_type}:{app_id}"
    
    def build_entitlement_bundle_orn(self, bundle_id: str) -> str:
        """Build ORN for an entitlement bundle"""
        return f"orn:okta:governance:{self.org_name}:entitlement-bundles:{bundle_id}"


def load_config(config_file: str) -> Dict:
    """Load configuration from JSON file"""
    with open(config_file, 'r') as f:
        return json.load(f)


def apply_configuration(manager: OktaAPIManager, config: Dict):
    """Apply resource owners and labels from configuration"""
    print("\n=== Applying Resource Owners and Labels ===\n")
    
    # Create labels
    if "labels" in config:
        print("Creating labels...")
        for label in config["labels"]:
            manager.create_label(
                name=label.get("name"),
                description=label.get("description", "")
            )
    
    # Assign resource owners
    if "resource_owners" in config:
        print("\nAssigning resource owners...")
        for assignment in config["resource_owners"]:
            principal_orns = [
                manager.build_user_orn(uid) if assignment["principal_type"] == "user"
                else manager.build_group_orn(uid)
                for uid in assignment["principal_ids"]
            ]
            
            resource_type = assignment.get("resource_type", "app")
            if resource_type == "app":
                resource_orns = [
                    manager.build_app_orn(rid, assignment.get("app_type", "oauth2"))
                    for rid in assignment["resource_ids"]
                ]
            elif resource_type == "group":
                resource_orns = [manager.build_group_orn(rid) for rid in assignment["resource_ids"]]
            else:
                resource_orns = assignment["resource_orns"]
            
            manager.assign_resource_owners(principal_orns, resource_orns)
    
    # Apply labels to resources
    if "label_assignments" in config:
        print("\nApplying labels to resources...")
        for assignment in config["label_assignments"]:
            label_name = assignment["label_name"]
            
            resource_type = assignment.get("resource_type", "app")
            if resource_type == "app":
                resource_orns = [
                    manager.build_app_orn(rid, assignment.get("app_type", "oauth2"))
                    for rid in assignment["resource_ids"]
                ]
            elif resource_type == "group":
                resource_orns = [manager.build_group_orn(rid) for rid in assignment["resource_ids"]]
            else:
                resource_orns = assignment["resource_orns"]
            
            manager.apply_labels_to_resources(label_name, resource_orns)
    
    print("\n✅ Configuration applied successfully!")


def destroy_configuration(manager: OktaAPIManager, config: Dict):
    """Remove resource owners and labels"""
    print("\n=== Removing Resource Owners and Labels ===\n")
    
    # Remove label assignments
    if "label_assignments" in config:
        print("Removing label assignments...")
        for assignment in config["label_assignments"]:
            label_name = assignment["label_name"]
            
            resource_type = assignment.get("resource_type", "app")
            if resource_type == "app":
                resource_orns = [
                    manager.build_app_orn(rid, assignment.get("app_type", "oauth2"))
                    for rid in assignment["resource_ids"]
                ]
            elif resource_type == "group":
                resource_orns = [manager.build_group_orn(rid) for rid in assignment["resource_ids"]]
            else:
                resource_orns = assignment["resource_orns"]
            
            try:
                manager.remove_label_from_resources(label_name, resource_orns)
            except Exception as e:
                print(f"Warning: Could not remove labels: {e}")
    
    # Remove resource owners
    if "resource_owners" in config:
        print("\nRemoving resource owners...")
        for assignment in config["resource_owners"]:
            principal_orns = [
                manager.build_user_orn(uid) if assignment["principal_type"] == "user"
                else manager.build_group_orn(uid)
                for uid in assignment["principal_ids"]
            ]
            
            resource_type = assignment.get("resource_type", "app")
            if resource_type == "app":
                resource_orns = [
                    manager.build_app_orn(rid, assignment.get("app_type", "oauth2"))
                    for rid in assignment["resource_ids"]
                ]
            elif resource_type == "group":
                resource_orns = [manager.build_group_orn(rid) for rid in assignment["resource_ids"]]
            else:
                resource_orns = assignment["resource_orns"]
            
            for resource_orn in resource_orns:
                for principal_orn in principal_orns:
                    try:
                        manager.remove_resource_owner(resource_orn, principal_orn)
                    except Exception as e:
                        print(f"Warning: Could not remove owner: {e}")
    
    print("\n✅ Configuration destroyed successfully!")


def main():
    parser = argparse.ArgumentParser(
        description="Manage Okta OIG Resource Owners and Labels"
    )
    parser.add_argument(
        "--action",
        choices=["apply", "destroy", "query"],
        required=True,
        help="Action to perform"
    )
    parser.add_argument(
        "--config",
        required=True,
        help="Path to configuration JSON file"
    )
    parser.add_argument(
        "--org-name",
        help="Okta organization name (overrides config)"
    )
    parser.add_argument(
        "--base-url",
        default="okta.com",
        help="Okta base URL (default: okta.com)"
    )
    parser.add_argument(
        "--api-token",
        help="Okta API token (overrides config)"
    )
    
    args = parser.parse_args()
    
    # Load configuration
    config = load_config(args.config)
    
    # Get credentials
    org_name = args.org_name or config.get("okta_org_name")
    api_token = args.api_token or config.get("okta_api_token")
    
    if not org_name or not api_token:
        print("Error: Okta org name and API token required")
        sys.exit(1)
    
    # Initialize manager
    manager = OktaAPIManager(org_name, args.base_url, api_token)
    
    # Perform action
    if args.action == "apply":
        apply_configuration(manager, config)
    elif args.action == "destroy":
        destroy_configuration(manager, config)
    elif args.action == "query":
        # Query current state
        print("\n=== Current State ===\n")
        
        print("Labels:")
        labels = manager.list_labels()
        for label in labels.get("data", []):
            print(f"  - {label.get('name')}: {label.get('description')}")
        
        print("\nResource Owners:")
        if "query_resources" in config:
            for resource in config["query_resources"]:
                owners = manager.list_resource_owners(resource)
                print(f"  Resource: {resource}")
                for item in owners.get("data", []):
                    principals = item.get("principals", [])
                    print(f"    Owners: {len(principals)}")


if __name__ == "__main__":
    main()
