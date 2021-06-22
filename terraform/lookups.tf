data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_kms_key" "s3" {
  key_id = "alias/aws/s3"
}

data "aws_vpc" "vpc" {
  id = local.vpc_id
}

data "aws_subnet_ids" "subnets" {
  vpc_id = local.vpc_id

  tags = local.subnet_tags
}

data "aws_subnet" "subnet" {
  for_each = data.aws_subnet_ids.subnets.ids
  id       = each.value
}