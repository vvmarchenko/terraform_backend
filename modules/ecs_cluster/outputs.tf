output "aws_security_group_ecs_cluster_asg" {
  value = aws_security_group.ecs_cluster_asg.id
}

output "aws_ecs_capacity_provider" {
  value = aws_ecs_capacity_provider.this.name
}

output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "repository_url" {
  value = aws_ecr_repository.this.repository_url
}
