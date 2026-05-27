variable "resource_arn" {
  type        = string
  description = "ARN of the resource to associate with the Web ACL (ALB, API Gateway, AppSync, Cognito User Pool, or App Runner)."
  validation {
    condition     = can(regex("^arn:aws", var.resource_arn))
    error_message = "Resource ARN must be a valid AWS ARN."
  }
}

variable "web_acl_arn" {
  type        = string
  description = "ARN of the WAFv2 Web ACL to associate."
  validation {
    condition     = can(regex("^arn:aws", var.web_acl_arn))
    error_message = "Web ACL ARN must be a valid AWS ARN."
  }
}
