# Get current AWS account ID for URL construction
data "aws_caller_identity" "current" {}
# Get list of ALL ECR repositories to check existence
data "aws_ecr_repositories" "all" {}
locals {
  # Check if our repo name exists in the list of all repos
  ecr_exists = contains(data.aws_ecr_repositories.all.names, var.ecr_repo_name)
  
  # Construct the URL manually to avoid needing a conditional data source
  # Format: <account_id>.dkr.ecr.<region>.amazonaws.com/<repo_name>
  repo_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repo_name}"
}
# Create ECR repo ONLY if it does NOT exist
resource "aws_ecr_repository" "app_repo" {
  count = local.ecr_exists ? 0 : 1
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
# ECS Cluster (Always managed)
resource "aws_ecs_cluster" "main_cluster" {
  name = var.ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
