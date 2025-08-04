# TFLint Configuration for Board Games Infrastructure
# Configuración robusta para terraform_tflint hook en pre-commit

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

# Rule configuration - Terraform core rules
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

# AWS plugin rules are enabled by default when the plugin is loaded
# We let the plugin use its default rules rather than specifying individual ones
# This avoids issues with non-existent rule names in different plugin versions
