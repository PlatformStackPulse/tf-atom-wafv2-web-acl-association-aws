resource "aws_wafv2_web_acl_association" "this" {
  count = local.enabled ? 1 : 0

  resource_arn = var.resource_arn
  web_acl_arn  = var.web_acl_arn
}
