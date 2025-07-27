# Monitoring Module for Calavia EKS Infrastructure

This module is responsible for setting up monitoring and alerting for the EKS cluster using the kube-prometheus stack. It includes configurations for Prometheus, Grafana, and Alertmanager to ensure that the cluster's health and performance are continuously monitored.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "monitoring" {
  source = "../modules/monitoring"

  # Add your specific variables here
}
```

## Variables

This module accepts the following variables:

- `prometheus_retention`: Duration for which Prometheus retains data (e.g., "3d" for production, "1d" for staging).
- `grafana_admin_password`: Password for the Grafana admin user.
- `alertmanager_config`: Configuration settings for Alertmanager.

## Outputs

This module provides the following outputs:

- `grafana_url`: The URL to access the Grafana dashboard.
- `prometheus_url`: The URL to access the Prometheus dashboard.
- `alertmanager_url`: The URL to access the Alertmanager interface.

## Monitoring Stack Components

The kube-prometheus stack includes:

- **Prometheus**: For metrics collection and storage.
- **Grafana**: For visualizing metrics and creating dashboards.
- **Alertmanager**: For handling alerts and notifications.

## Security Considerations

Ensure that access to the monitoring interfaces is restricted to authorized users only. Use IAM roles and security groups to enforce access controls.

## License

This module is licensed under the MIT License.