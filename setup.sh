#!/bin/bash
# setup.sh - Initial setup script for Okta Terraform OIG Demo

set -e

echo "🚀 Okta Terraform OIG Demo Setup"
echo "================================="
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check Terraform
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform not found. Please install Terraform >= 1.9.0"
    echo "   Visit: https://www.terraform.io/downloads"
    exit 1
fi

TERRAFORM_VERSION=$(terraform version -json | grep -o '"terraform_version":"[^"]*' | cut -d'"' -f4)
echo "✅ Terraform version: $TERRAFORM_VERSION"

# Check Git
if ! command -v git &> /dev/null; then
    echo "❌ Git not found. Please install Git"
    exit 1
fi
echo "✅ Git installed"

# Check GitHub CLI (optional)
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI installed"
    HAS_GH=true
else
    echo "ℹ️  GitHub CLI not found (optional)"
    HAS_GH=false
fi

echo ""
echo "Creating directory structure..."

# Create directories
mkdir -p .github/workflows
mkdir -p terraform

echo "✅ Directories created"

# Copy example files if they don't exist
echo ""
echo "Setting up configuration files..."

if [ ! -f terraform/terraform.tfvars ]; then
    if [ -f terraform/terraform.tfvars.example ]; then
        cp terraform/terraform.tfvars.example terraform/terraform.tfvars
        echo "✅ Created terraform.tfvars from example"
        echo "⚠️  Please edit terraform/terraform.tfvars with your values"
    else
        echo "⚠️  terraform.tfvars.example not found"
    fi
else
    echo "ℹ️  terraform.tfvars already exists"
fi

# Initialize git if not already initialized
if [ ! -d .git ]; then
    echo ""
    echo "Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit: Okta Terraform OIG Demo"
    echo "✅ Git repository initialized"
else
    echo "ℹ️  Git repository already initialized"
fi

echo ""
echo "Configuration checklist:"
echo "========================"
echo ""
echo "1. ✏️  Edit terraform/terraform.tfvars with your Okta credentials"
echo "2. 🔧 Update backend configuration in terraform/main.tf"
echo "3. 🔐 Set up GitHub Secrets:"
echo "   - OKTA_ORG_NAME"
echo "   - OKTA_BASE_URL"
echo "   - OKTA_API_TOKEN"
echo "4. 🧪 Test locally:"
echo "   cd terraform && terraform init && terraform plan"
echo "5. 📤 Push to GitHub:"
echo "   git remote add origin <your-repo-url>"
echo "   git push -u origin main"
echo ""

# Offer to set GitHub secrets if gh CLI is available
if [ "$HAS_GH" = true ]; then
    echo "Would you like to set up GitHub secrets now? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo ""
        echo "Setting up GitHub secrets..."
        
        # Check if we're in a GitHub repo
        if gh repo view &> /dev/null; then
            echo "Enter your Okta organization name:"
            read -r OKTA_ORG
            gh secret set OKTA_ORG_NAME --body "$OKTA_ORG"
            
            echo "Enter your Okta base URL (okta.com or oktapreview.com):"
            read -r OKTA_URL
            gh secret set OKTA_BASE_URL --body "$OKTA_URL"
            
            echo "Enter your Okta API token:"
            read -rs OKTA_TOKEN
            gh secret set OKTA_API_TOKEN --body "$OKTA_TOKEN"
            
            echo ""
            echo "✅ GitHub secrets configured"
        else
            echo "⚠️  Not in a GitHub repository. Push to GitHub first."
        fi
    fi
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Review and customize terraform/main.tf for your needs"
echo "2. Run 'cd terraform && terraform init' to initialize"
echo "3. Run 'terraform plan' to preview changes"
echo "4. Push to GitHub to trigger the CI/CD pipeline"
echo ""
echo "For more information, see README.md"
echo ""
