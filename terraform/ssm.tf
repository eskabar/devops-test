resource "aws_ssm_parameter" "build_version" {
  name  = "/${local.family}/build-version"
  type  = "String"
  value = "0"
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "redis_url" {
  name  = "/${local.family}/redis"
  type  = "SecureString"
  value = "redis://redis:6379"
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "mongodb_uri" {
  name  = "/${local.family}/mongo"
  type  = "SecureString"
  value = "mongodb://localhost/"
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}