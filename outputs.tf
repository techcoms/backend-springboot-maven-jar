output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  # Use the URL we constructed in the local variable (defined in main.tf? No, output cannot access locals from another file directly unless export? 
  # Actually, outputs can't read locals. We need to reconstruct it or handle the logic here.
  # Better approach: The URL is predictable.
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repo_name}"
}
output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main_cluster.name
}
output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.main_cluster.arn
}
