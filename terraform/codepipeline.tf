resource "aws_codepipeline" "codepipeline" {
  name     = "${local.family}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = local.s3_bucket
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_key.s3.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "GitHubCodeStar"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn        = local.codestar_connection_arn
        FullRepositoryId     = local.full_repository_id
        BranchName           = local.branch_name
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName       = local.ecs_cluster
        ServiceName       = aws_ecs_service.service.name
        FileName          = "imagedefinitions.json"
        DeploymentTimeout = "10"
      }
    }
  }

  depends_on = [
    aws_iam_role_policy.codepipeline
  ]
}

resource "aws_codepipeline_webhook" "hook" {
  name            = "${local.family}-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline.name

  authentication_configuration {
    secret_token = local.webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

