variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}
variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "my-java-app"
}
variable "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
  default     = "my-production-cluster"
}
