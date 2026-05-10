#!/bin/bash
set -e

# Deploy Terraform Cloudflare Configuration
# This script validates and applies the Terraform configuration to fix all Cloudflare security warnings

echo "🚀 Cloudflare Terraform Deployment Script"
echo "=========================================="
echo ""

# Check prerequisites
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform not found. Install from https://www.terraform.io/downloads"
    exit 1
fi

if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "❌ CLOUDFLARE_API_TOKEN not set. Set it:"
    echo "   export CLOUDFLARE_API_TOKEN='your-token'"
    exit 1
fi

if [ -z "$CLOUDFLARE_ACCOUNT_ID" ]; then
    echo "❌ CLOUDFLARE_ACCOUNT_ID not set. Set it:"
    echo "   export CLOUDFLARE_ACCOUNT_ID='your-account-id'"
    exit 1
fi

echo "✅ Prerequisites OK"
echo ""

# Step 1: Initialize
echo "📦 Step 1: Initialize Terraform..."
terraform init
echo "✅ Terraform initialized"
echo ""

# Step 2: Validate
echo "🔍 Step 2: Validating Terraform configuration..."
terraform validate
echo "✅ Configuration is valid"
echo ""

# Step 3: Format check
echo "🎨 Step 3: Checking Terraform formatting..."
terraform fmt -check -recursive
echo "✅ Formatting is correct"
echo ""

# Step 4: Plan
echo "📋 Step 4: Planning Terraform changes..."
terraform plan -out=tfplan
echo "✅ Plan created (tfplan)"
echo ""

# Step 5: Ask for approval
echo "🤔 Review the plan above."
read -p "Do you want to apply these changes? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

echo ""
echo "🚀 Step 5: Applying Terraform changes..."
terraform apply tfplan
echo "✅ Changes applied!"
echo ""

echo "✨ Deployment complete!"
echo ""
echo "📊 Next steps:"
echo "1. Go to https://dash.cloudflare.com"
echo "2. Click Security → Security Insights"
echo "3. Click 'Scan now' to verify all warnings are fixed"
echo ""
echo "✅ All 23 security warnings should now be resolved!"
