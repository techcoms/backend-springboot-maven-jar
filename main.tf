# Get all ECR repositories
data "aws_ecr_repositories" "all" {}

locals {
  ecr_exists = contains(
    data.aws_ecr_repositories.all.names,
    var.ecr_repo_name
  )
}

# Create ECR repo only if it does NOT exist
resource "aws_ecr_repository" "app_repo" {
  count = local.ecr_exists ? 0 : 1

  name = var.ecr_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "main_cluster" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
