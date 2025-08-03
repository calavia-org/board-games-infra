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
- `ManagedBy`: Management tool (terraform)

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
