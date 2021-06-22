resource "aws_codebuild_project" "build" {
  name          = "${local.family}-build"
  service_role  = aws_iam_role.codebuild.arn
  build_timeout = "10"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "true"

    environment_variable {
      name  = "ARTIFACT_VERSION_PARAMETER_NAME"
      value = aws_ssm_parameter.build_version.name
    }

    environment_variable {
      name  = "ECR_REPOSITORY_BASE_URL"
      value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com"
    }

    environment_variable {
      name  = "ECR_REPOSITORY_NAME"
      value = local.ecr_repository_name
    }

    environment_variable {
      name  = "ENV"
      value = local.env
    }

    environment_variable {
      name  = "TASK_ROLE_ARN"
      value = aws_iam_role.task_execution_role.arn
    }

    environment_variable {
      name  = "EXECUTION_ROLE_ARN"
      value = aws_iam_role.ecs_execution_role.arn
    }

    environment_variable {
      name  = "CLOUDWATCH_LOG_GROUP"
      value = aws_cloudwatch_log_group.log.name
    }

    environment_variable {
      name  = "FAMILY"
      value = local.family
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = local.buildspec_path
  }

  tags = local.tags
}