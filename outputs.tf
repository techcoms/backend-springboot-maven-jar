output "ecs_cluster_name" {
  value = aws_ecs_cluster.main_cluster.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.main_cluster.arn
}
