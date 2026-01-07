output "ecr_repository_url" {
  value = local.ecr_exists
    ? data.aws_ecr_repository.existing.repository_url
    : aws_ecr_repository.app_repo[0].repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main_cluster.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.main_cluster.arn
}
