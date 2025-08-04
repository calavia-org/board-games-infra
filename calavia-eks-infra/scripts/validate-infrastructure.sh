#!/bin/bash

# Infrastructure Validation Script for Board Games Platform
# This script validates that all Terraform modules are properly configured

set -e

echo "🎮 Board Games Infrastructure Validation Script"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo -e "${RED}❌ Error: main.tf not found. Please run this script from the calavia-eks-infra directory${NC}"
    exit 1
fi

echo "📁 Current directory: $(pwd)"
echo ""

# Function to check if a module directory exists and has required files
check_module() {
    local module_name=$1
    local module_path="modules/$module_name"

    echo -n "🔍 Checking module: $module_name... "

    if [ ! -d "$module_path" ]; then
        echo -e "${RED}❌ MISSING${NC}"
        return 1
    fi

    # Check for required files
    local required_files=("main.tf" "variables.tf" "outputs.tf" "README.md")
    local missing_files=()

    for file in "${required_files[@]}"; do
        if [ ! -f "$module_path/$file" ]; then
            missing_files+=("$file")
        fi
    done

    if [ ${#missing_files[@]} -eq 0 ]; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Missing files: ${missing_files[*]}${NC}"
        return 1
    fi
}

# Function to validate Terraform syntax
validate_terraform() {
    echo "🔧 Validating Terraform configuration..."

    if command -v terraform &> /dev/null; then
        echo "   📋 Running terraform init..."
        if terraform init -backend=false > /dev/null 2>&1; then
            echo -e "   ${GREEN}✅ Terraform init successful${NC}"
        else
            echo -e "   ${RED}❌ Terraform init failed${NC}"
            return 1
        fi

        echo "   📋 Running terraform validate..."
        if terraform validate > /dev/null 2>&1; then
            echo -e "   ${GREEN}✅ Terraform configuration is valid${NC}"
        else
            echo -e "   ${RED}❌ Terraform validation failed${NC}"
            terraform validate
            return 1
        fi
    else
        echo -e "   ${YELLOW}⚠️  Terraform not found, skipping validation${NC}"
    fi
}

# Function to check for sensitive variables
check_sensitive_vars() {
    echo "🔐 Checking for sensitive variables configuration..."

    local sensitive_found=0

    # Check for sensitive variables in terraform files
    if grep -r "sensitive.*=.*true" . > /dev/null 2>&1; then
        echo -e "   ${GREEN}✅ Sensitive variables properly marked${NC}"
        sensitive_found=1
    fi

    # Check for secrets manager references
    if grep -r "aws_secretsmanager_secret" . > /dev/null 2>&1; then
        echo -e "   ${GREEN}✅ Secrets Manager integration found${NC}"
        sensitive_found=1
    fi

    if [ $sensitive_found -eq 0 ]; then
        echo -e "   ${YELLOW}⚠️  No sensitive variable configuration found${NC}"
    fi
}

# Function to check Lambda functions
check_lambda_functions() {
    echo "🚀 Checking Lambda functions for secrets rotation..."

    local lambda_dir="modules/secrets-manager/lambda_functions"

    if [ -d "$lambda_dir" ]; then
        local expected_functions=("postgres_rotation.py" "redis_rotation.py" "sa_token_rotation.py")
        local missing_functions=()

        for func in "${expected_functions[@]}"; do
            if [ ! -f "$lambda_dir/$func" ]; then
                missing_functions+=("$func")
            fi
        done

        if [ ${#missing_functions[@]} -eq 0 ]; then
            echo -e "   ${GREEN}✅ All Lambda functions present${NC}"
        else
            echo -e "   ${YELLOW}⚠️  Missing Lambda functions: ${missing_functions[*]}${NC}"
        fi
    else
        echo -e "   ${RED}❌ Lambda functions directory not found${NC}"
    fi
}

# Main validation
echo "🏗️  Validating Infrastructure Modules"
echo "====================================="

# List of expected modules
modules=(
    "vpc"
    "security"
    "eks"
    "rds-postgres"
    "elasticache-redis"
    "alb-ingress"
    "external-dns"
    "cert-manager"
    "monitoring"
    "secrets-manager"
)

failed_modules=()

for module in "${modules[@]}"; do
    if ! check_module "$module"; then
        failed_modules+=("$module")
    fi
done

echo ""

# Validate Terraform configuration
validate_terraform
echo ""

# Check sensitive variables
check_sensitive_vars
echo ""

# Check Lambda functions
check_lambda_functions
echo ""

# Summary
echo "📊 VALIDATION SUMMARY"
echo "===================="

total_modules=${#modules[@]}
failed_count=${#failed_modules[@]}
success_count=$((total_modules - failed_count))

echo "Total modules: $total_modules"
echo -e "✅ Successful: ${GREEN}$success_count${NC}"

if [ $failed_count -gt 0 ]; then
    echo -e "❌ Failed: ${RED}$failed_count${NC}"
    echo -e "Failed modules: ${RED}${failed_modules[*]}${NC}"
else
    echo -e "❌ Failed: ${GREEN}0${NC}"
fi

echo ""

# Final result
if [ $failed_count -eq 0 ]; then
    echo -e "${GREEN}🎉 SUCCESS: All infrastructure modules are properly configured!${NC}"
    echo ""
    echo "🚀 Next steps:"
    echo "   1. Configure your terraform.tfvars file"
    echo "   2. Run 'terraform plan' to review changes"
    echo "   3. Run 'terraform apply' to deploy infrastructure"
    echo "   4. Validate secrets rotation is working"
    echo ""
    exit 0
else
    echo -e "${RED}❌ VALIDATION FAILED: Please fix the issues above before proceeding${NC}"
    echo ""
    exit 1
fi
