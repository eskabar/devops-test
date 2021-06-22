resource "aws_ecs_cluster" "cluster" {
  name = local.ecs_cluster
}

resource "aws_ecr_repository" "ecr" {
  name = local.ecr_repository_name
}

locals {
  container_definitions = {
    container_name       = local.container_name
    family               = local.family
    task_role_arn        = aws_iam_role.task_execution_role.arn
    execution_role_arn   = aws_iam_role.ecs_execution_role.arn
    image                = "${data.aws_caller_identity.current.id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.ecr_repository_name}"
    cpu                  = local.cpu
    memory               = local.memory
    port                 = local.container_port
    cloudwatch_log_group = local.family
    region               = data.aws_region.current.name
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = local.family
  container_definitions    = templatefile("template_files/container_definitions.json", local.container_definitions)
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  cpu                      = local.cpu
  memory                   = local.memory
  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }
}

resource "aws_ecs_service" "service" {
  name            = local.family
  cluster         = aws_ecs_cluster.cluster.name
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = local.desired_count
  launch_type     = "FARGATE"

  depends_on = [
    aws_iam_role_policy_attachment.task_execution,
    aws_iam_role_policy_attachment.task_access,
    aws_iam_role.task_execution_role
  ]

  network_configuration {
    subnets          = data.aws_subnet_ids.subnets.ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = "true"
  }

  deployment_controller {
    type = "ECS"
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      load_balancer
    ]
  }
}