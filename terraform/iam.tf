#ECS
data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com", "ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${local.family}-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  tags               = local.tags
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${local.family}-ecs-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "task_access" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_access" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

data "aws_iam_policy_document" "custom" {
  statement {

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "*",
    ]
  }

  statement {

    actions = [
      "ssm:Get*",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "task_custom" {
  name   = "custom"
  role   = aws_iam_role.task_execution_role.id
  policy = data.aws_iam_policy_document.custom.json
}

resource "aws_iam_role_policy" "ecs_custom" {
  name   = "custom"
  role   = aws_iam_role.ecs_execution_role.id
  policy = data.aws_iam_policy_document.custom.json
}

#Pipeline
data "aws_iam_policy_document" "codepipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "${local.family}-codepipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json
  tags               = local.tags
}


data "aws_iam_policy_document" "codepipeline" {
  statement {

    actions = [
      "iam:PassRole"
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "codedeploy.amazonaws.com",
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }

  statement {

    actions = [
      "codestar-connections:*",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "ecr:DescribeImages",
      "s3:Get*",
      "s3:Put*",
      "s3:List*",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "codedeploy:CreateDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:RegisterApplicationRevision",
      "codedeploy:GetDeploymentConfig",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "codepipeline" {
  name = "codepipeline"
  role = aws_iam_role.codepipeline.id

  policy = data.aws_iam_policy_document.codepipeline.json
}

# CODEBUILD
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${local.family}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
  tags               = local.tags
}

data "aws_iam_policy_document" "codebuild" {
  statement {

    actions = [
      "codestar-connections:*",
      "ecr:Get*",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "s3:Get*",
      "s3:Put*",
      "s3:List*",
      "ssm:Get*",
      "ssm:Put*",
      "ec2:Describe*",
      "logs:*",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name = "codebuild"
  role = aws_iam_role.codebuild.id

  policy = data.aws_iam_policy_document.codebuild.json
}


#CODE DEPLOY
data "aws_iam_policy_document" "codedeploy_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy" {
  name               = "${local.family}-codedeploy"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role_policy.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}