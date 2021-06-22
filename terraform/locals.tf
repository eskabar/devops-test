locals {
  #global
  container_name = "webapp"
  env            = terraform.workspace
  family         = "${local.container_name}-${local.env}"

  #network
  vpc_id = "vpc-09a6813f13202c4fa"
  subnet_tags = {
    type = "public"
  }

  #pipeline
  buildspec_path          = "buildspec.yaml"
  taskdefinition_filename = "taskdefinition.json"
  s3_bucket               = "simplecontainer-pipeline-artifacts-us-east-2"
  codestar_connection_arn = "arn:aws:codestar-connections:us-east-2:264326320119:connection/91777cc9-480b-432f-9385-d0c939e4205d"
  full_repository_id      = "eskabar/devops-test"
  branch_name             = "main"
  webhook_secret          = "SuperSecret"
  ecr_repository_name     = "webapp"

  #ecs/container
  container_port = "5000"
  desired_count  = "0"
  cpu            = "256"
  memory         = "512"
  ecs_cluster    = "webapp"

  tags = {
    Name        = local.container_name
    Environment = local.env
  }
}