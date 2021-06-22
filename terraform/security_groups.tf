#ECS
resource "aws_security_group" "ecs" {
  name   = "${local.family}-ecs"
  vpc_id = local.vpc_id

  tags = local.tags
}

resource "aws_security_group_rule" "ecs_ingress" {
  type              = "ingress"
  from_port         = local.container_port
  to_port           = local.container_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group" "codebuild" {
  name   = "${local.family}-codebuild"
  vpc_id = local.vpc_id

  tags = local.tags
}

resource "aws_security_group_rule" "codebuild_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.codebuild.id
}