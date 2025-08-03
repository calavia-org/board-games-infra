output "tags" {
  description = "Complete set of tags for all resources"
  value       = module.tags.tags
}

output "mandatory_tags" {
  description = "Only mandatory tags"
  value       = module.tags.mandatory_tags
}

output "cost_tags" {
  description = "Tags optimized for cost tracking and management"
  value       = module.tags.cost_tags
}

output "monitoring_tags" {
  description = "Tags for monitoring, alerting and observability"
  value       = module.tags.monitoring_tags
}

output "enriched_tags" {
  description = "Tags with AWS account and region information"
  value       = module.tags.enriched_tags
}
