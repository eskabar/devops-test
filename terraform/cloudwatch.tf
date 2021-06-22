resource "aws_cloudwatch_log_group" "log" {
  name = local.family
  tags = local.tags
}
