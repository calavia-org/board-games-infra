# TFLint Configuration for Board Games Infrastructure
# Configuración para terraform_tflint hook en pre-commit

# Plugin configuration
plugin "aws" {
  enabled = true
  version = "0.29.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Global configuration
config {
  # Disable default rules that might be too strict
  disabled_by_default = false
  
  # Call module inspection (expensive but thorough)
  call_module_type = "all"
  
  # Force check mode to avoid making changes
  force = false
  
  # Disable color output for CI/CD environments
  format = "compact"
}

# Rule configuration
rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
  style = "semver"
}

rule "terraform_naming_convention" {
  enabled = true
  format = "snake_case"
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

# AWS-specific rules
rule "aws_instance_invalid_type" {
  enabled = true
}

rule "aws_instance_previous_type" {
  enabled = true
}

rule "aws_db_instance_invalid_type" {
  enabled = true
}

rule "aws_elasticache_cluster_invalid_type" {
  enabled = true
}

rule "aws_eks_cluster_invalid_version" {
  enabled = true
}

rule "aws_iam_policy_invalid_policy" {
  enabled = true
}

rule "aws_iam_role_invalid_policy" {
  enabled = true
}

rule "aws_security_group_invalid_protocol" {
  enabled = true
}

rule "aws_route_invalid_route_table" {
  enabled = true
}

rule "aws_alb_invalid_subnet" {
  enabled = true
}

rule "aws_alb_invalid_security_group" {
  enabled = true
}

# Disable some rules that might be too restrictive for our use case
rule "aws_instance_invalid_ami" {
  enabled = false  # AMIs change frequently, especially for ARM64
}

rule "aws_launch_configuration_invalid_image_id" {
  enabled = false  # Same as above for launch configurations
}
