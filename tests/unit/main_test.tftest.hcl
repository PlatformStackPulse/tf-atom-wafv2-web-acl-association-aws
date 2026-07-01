# Unit Tests for tf-atom-wafv2-web-acl-association-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:   terraform test -test-directory=tests/unit
# Run verbose: terraform test -test-directory=tests/unit -verbose
#
# Assertions target plan-KNOWN values only (tf-label id, resource count,
# enabled flag). Computed values such as the association id/arn are unknown
# under a mock provider and are therefore NOT asserted on.

mock_provider "aws" {}

variables {
  # tf-label context inputs
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-specific required inputs (valid-looking ARNs)
  resource_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-alb/50dc6c495c0c9188"
  web_acl_arn  = "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/my-web-acl/12345678-1234-1234-1234-123456789012"
}

# ---------------------------------------------------------------------------
# Test: module creates the association when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = module.this.id == "eg-test-thing"
    error_message = "tf-label id should be 'eg-test-thing'"
  }

  assert {
    condition     = length(aws_wafv2_web_acl_association.this) == 1
    error_message = "Exactly one association resource should be planned when enabled"
  }

  assert {
    condition     = aws_wafv2_web_acl_association.this[0].resource_arn == var.resource_arn
    error_message = "resource_arn input should pass through to the resource"
  }

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true by default"
  }
}

# ---------------------------------------------------------------------------
# Test: module creates nothing when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_wafv2_web_acl_association.this) == 0
    error_message = "No association resource should be planned when enabled = false"
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when disabled"
  }
}
