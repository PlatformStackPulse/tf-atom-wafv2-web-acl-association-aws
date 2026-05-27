output "association_id" {
  description = "The ID of the WAFv2 Web ACL Association."
  value       = try(aws_wafv2_web_acl_association.this[0].id, "")
}

output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}
