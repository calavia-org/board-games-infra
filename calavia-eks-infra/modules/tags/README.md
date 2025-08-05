# Tags Module README

## Overview

This module provides a centralized, consistent tagging strategy for all AWS resources in the Board Games Infrastructure project. It implements a comprehensive tagging taxonomy designed for:

- **Cost Management**: Detailed cost tracking and allocation
- **Compliance**: Mandatory tags for governance and auditing
- **Automation**: Lifecycle management and maintenance automation
- **Monitoring**: Enhanced observability and alerting
- **Security**: Resource ownership and access control

## Usage

### Basic Usage

```hcl
module "tags" {
  source = "./modules/tags"

  environment  = "production"
  owner_email  = "devops@calavia.org"
  component    = "database"
  purpose      = "game-data-storage"
  criticality  = "critical"
}

# Apply tags to resources
resource "aws_rds_db_instance" "game_db" {
  # ... other configuration ...

  tags = module.tags.tags
}
```

### Advanced Usage with Custom Tags

```hcl
module "database_tags" {
  source = "./modules/tags"

  environment           = var.environment
  owner_email          = "database-team@calavia.org"
  component            = "database"
  purpose              = "primary-game-database"
  criticality          = "critical"
  maintenance_window   = "Sunday-03:00"
  expiry_date          = "2026-12-31"

  additional_tags = {
    DatabaseEngine    = "postgresql"
    BackupRetention   = "30-days"
    EncryptionEnabled = "true"
    MultiAZ           = "true"
  }
}

resource "aws_rds_db_instance" "main" {
  tags = module.database_tags.enriched_tags
}
```

## Tag Categories

### Mandatory Tags (Always Applied)

- `Environment`: Environment name
- `Project`: Project identifier
- `Owner`: Responsible team/person
- `CostCenter`: Billing cost center
- `ManagedBy`: Management tool (Terraform)

### Business Tags

- `BusinessUnit`: Business unit name
- `Department`: Responsible department
- `Criticality`: Resource criticality level

### Technical Tags

- `CreatedBy`: Creation source
- `CreatedDate`: Creation timestamp
- `Version`: Infrastructure version
- `Architecture`: System architecture
- `Component`: Service component type
- `Purpose`: Resource purpose

### Lifecycle Tags

- `MaintenanceWindow`: Maintenance schedule
- `ExpiryDate`: Resource expiration (optional)

### Cost Management Tags

- `BillingProject`: Billing project code
- `BudgetAlerts`: Budget alerting status
- `CostOptimization`: Optimization status

### Environment-Specific Tags

Production:

- `Backup`: required
- `Monitoring`: enhanced
- `ReservedInstance`: candidate

Staging:

- `Backup`: weekly
- `Monitoring`: standard
- `ScheduleShutdown`: enabled

Development/Testing:

- `Backup`: optional
- `Monitoring`: basic
- `ScheduleShutdown`: enabled

## Outputs

- `tags`: Complete tag set for resources
- `mandatory_tags`: Only mandatory tags
- `cost_tags`: Cost management optimized tags
- `monitoring_tags`: Monitoring/alerting tags
- `enriched_tags`: Tags with AWS account/region info

## Validation

The module includes validation for:

- Environment values
- Email format for owner
- Criticality levels
- Department names
- Maintenance window format
- Expiry date format

## Examples

### Database with Full Tagging

```hcl
module "db_tags" {
  source = "./modules/tags"

  environment        = "production"
  owner_email       = "database@calavia.org"
  component         = "database"
  purpose           = "user-data-storage"
  criticality       = "critical"
  maintenance_window = "Sunday-02:00"

  additional_tags = {
    Engine           = "postgresql"
    Version          = "14.9"
    BackupSchedule   = "daily"
    EncryptionKey    = "customer-managed"
  }
}
```

### EKS Cluster Tagging

```hcl
module "eks_tags" {
  source = "./modules/tags"

  environment  = var.environment
  owner_email  = "platform@calavia.org"
  component    = "container-orchestration"
  purpose      = "kubernetes-cluster"
  criticality  = "critical"

  additional_tags = {
    KubernetesVersion = "1.27"
    NodeGroups       = "3"
    AutoScaling      = "enabled"
  }
}
```

## Best Practices

1. **Always use the module**: Don't create tags manually
2. **Use specific components**: Be descriptive with component names
3. **Set appropriate criticality**: Impacts monitoring and alerting
4. **Include expiry dates**: For temporary resources
5. **Use additional_tags**: For resource-specific metadata
6. **Validate in CI/CD**: Check tag compliance in pipelines

## Integration with Cost Management

The tagging strategy integrates with:

- AWS Cost Explorer filters
- AWS Budgets
- Infracost analysis
- Custom cost reporting scripts

Example Cost Explorer filter:

```bash
aws ce get-cost-and-usage \
  --group-by Type=TAG,Key=Environment \
  --group-by Type=TAG,Key=Component \
  --filter-by Tags,Key=Project,Values=board-games
```
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to merge with the standard tags | `map(string)` | `{}` | no |
| <a name="input_billing_project"></a> [billing\_project](#input\_billing\_project) | Billing project identifier | `string` | `"BG-2025-Q3"` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Business unit name | `string` | `"Gaming-Platform"` | no |
| <a name="input_component"></a> [component](#input\_component) | Component or service type | `string` | `""` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center code for billing purposes | `string` | `"CC-001-GAMING"` | no |
| <a name="input_criticality"></a> [criticality](#input\_criticality) | Resource criticality level | `string` | `"medium"` | no |
| <a name="input_department"></a> [department](#input\_department) | Department responsible for the resource | `string` | `"Engineering"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development, testing) | `string` | n/a | yes |
| <a name="input_expiry_date"></a> [expiry\_date](#input\_expiry\_date) | Resource expiry date in YYYY-MM-DD format (for temporary resources) | `string` | `""` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Version of the infrastructure code | `string` | `"2.0.0"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window in format WEEKDAY-HH:MM | `string` | `"Sunday-03:00"` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email of the team/person responsible for the resource | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"board-games"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Purpose or description of the resource | `string` | `""` | no |
| <a name="input_service"></a> [service](#input\_service) | Service or application name that uses this resource | `string` | `"board-games-platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_billing_project"></a> [billing\_project](#output\_billing\_project) | Proyecto de facturación |
| <a name="output_cost_center"></a> [cost\_center](#output\_cost\_center) | Centro de costes para facturación |
| <a name="output_environment"></a> [environment](#output\_environment) | Entorno actual |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Nombre del proyecto |
| <a name="output_service"></a> [service](#output\_service) | Nombre del servicio |
| <a name="output_tags"></a> [tags](#output\_tags) | Map completo de tags para aplicar a recursos |
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to merge with the standard tags | `map(string)` | `{}` | no |
| <a name="input_billing_project"></a> [billing\_project](#input\_billing\_project) | Billing project identifier | `string` | `"BG-2025-Q3"` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Business unit name | `string` | `"Gaming-Platform"` | no |
| <a name="input_component"></a> [component](#input\_component) | Component or service type | `string` | `""` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center code for billing purposes | `string` | `"CC-001-GAMING"` | no |
| <a name="input_criticality"></a> [criticality](#input\_criticality) | Resource criticality level | `string` | `"medium"` | no |
| <a name="input_department"></a> [department](#input\_department) | Department responsible for the resource | `string` | `"Engineering"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development, testing) | `string` | n/a | yes |
| <a name="input_expiry_date"></a> [expiry\_date](#input\_expiry\_date) | Resource expiry date in YYYY-MM-DD format (for temporary resources) | `string` | `""` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Version of the infrastructure code | `string` | `"2.0.0"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window in format WEEKDAY-HH:MM | `string` | `"Sunday-03:00"` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email of the team/person responsible for the resource | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"board-games"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Purpose or description of the resource | `string` | `""` | no |
| <a name="input_service"></a> [service](#input\_service) | Service or application name that uses this resource | `string` | `"board-games-platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_billing_project"></a> [billing\_project](#output\_billing\_project) | Proyecto de facturación |
| <a name="output_cost_center"></a> [cost\_center](#output\_cost\_center) | Centro de costes para facturación |
| <a name="output_environment"></a> [environment](#output\_environment) | Entorno actual |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Nombre del proyecto |
| <a name="output_service"></a> [service](#output\_service) | Nombre del servicio |
| <a name="output_tags"></a> [tags](#output\_tags) | Map completo de tags para aplicar a recursos |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to merge with the standard tags | `map(string)` | `{}` | no |
| <a name="input_billing_project"></a> [billing\_project](#input\_billing\_project) | Billing project identifier | `string` | `"BG-2025-Q3"` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Business unit name | `string` | `"Gaming-Platform"` | no |
| <a name="input_component"></a> [component](#input\_component) | Component or service type | `string` | `""` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center code for billing purposes | `string` | `"CC-001-GAMING"` | no |
| <a name="input_criticality"></a> [criticality](#input\_criticality) | Resource criticality level | `string` | `"medium"` | no |
| <a name="input_department"></a> [department](#input\_department) | Department responsible for the resource | `string` | `"Engineering"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development, testing) | `string` | n/a | yes |
| <a name="input_expiry_date"></a> [expiry\_date](#input\_expiry\_date) | Resource expiry date in YYYY-MM-DD format (for temporary resources) | `string` | `""` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Version of the infrastructure code | `string` | `"2.0.0"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window in format WEEKDAY-HH:MM | `string` | `"Sunday-03:00"` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email of the team/person responsible for the resource | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"board-games"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Purpose or description of the resource | `string` | `""` | no |
| <a name="input_service"></a> [service](#input\_service) | Service or application name that uses this resource | `string` | `"board-games-platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_billing_project"></a> [billing\_project](#output\_billing\_project) | Proyecto de facturación |
| <a name="output_cost_center"></a> [cost\_center](#output\_cost\_center) | Centro de costes para facturación |
| <a name="output_environment"></a> [environment](#output\_environment) | Entorno actual |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Nombre del proyecto |
| <a name="output_service"></a> [service](#output\_service) | Nombre del servicio |
| <a name="output_tags"></a> [tags](#output\_tags) | Map completo de tags para aplicar a recursos |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to merge with the standard tags | `map(string)` | `{}` | no |
| <a name="input_billing_project"></a> [billing\_project](#input\_billing\_project) | Billing project identifier | `string` | `"BG-2025-Q3"` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Business unit name | `string` | `"Gaming-Platform"` | no |
| <a name="input_component"></a> [component](#input\_component) | Component or service type | `string` | `""` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center code for billing purposes | `string` | `"CC-001-GAMING"` | no |
| <a name="input_criticality"></a> [criticality](#input\_criticality) | Resource criticality level | `string` | `"medium"` | no |
| <a name="input_department"></a> [department](#input\_department) | Department responsible for the resource | `string` | `"Engineering"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development, testing) | `string` | n/a | yes |
| <a name="input_expiry_date"></a> [expiry\_date](#input\_expiry\_date) | Resource expiry date in YYYY-MM-DD format (for temporary resources) | `string` | `""` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Version of the infrastructure code | `string` | `"2.0.0"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window in format WEEKDAY-HH:MM | `string` | `"Sunday-03:00"` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email of the team/person responsible for the resource | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"board-games"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Purpose or description of the resource | `string` | `""` | no |
| <a name="input_service"></a> [service](#input\_service) | Service or application name that uses this resource | `string` | `"board-games-platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_billing_project"></a> [billing\_project](#output\_billing\_project) | Proyecto de facturación |
| <a name="output_cost_center"></a> [cost\_center](#output\_cost\_center) | Centro de costes para facturación |
| <a name="output_environment"></a> [environment](#output\_environment) | Entorno actual |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Nombre del proyecto |
| <a name="output_service"></a> [service](#output\_service) | Nombre del servicio |
| <a name="output_tags"></a> [tags](#output\_tags) | Map completo de tags para aplicar a recursos |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
