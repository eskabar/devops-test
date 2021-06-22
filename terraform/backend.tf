# terraform {
#   backend "s3" {
#     bucket  = "webapp-terraform-state-bucket-us-east-2"
#     key     = "webapp_fargate_codepipline_ecs"
#     region  = "us-east-2"
#     profile = "myaccount"
#   }
# }

provider "aws" {
  region  = "us-east-2"
  profile = "myaccount"
}
