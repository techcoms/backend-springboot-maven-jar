# Check if ECR repository already exists
data "aws_ecr_repository" "existing" {
  name = var.ecr_repo_name
}

# Local flag to determine existence
locals {
  ecr_exists = can(data.aws_ecr_repository.existing.repository_url)
}

# Create ECR repo ONLY if it does not exist
resource "aws_ecr_repository" "app_repo" {
  count = local.ecr_exists ? 0 : 1

  name = var.ecr_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECS Cluster (unchanged)
resource "aws_ecs_cluster" "main_cluster" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
