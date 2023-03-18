output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "aws_security_group_ecs_cluster_asg" {
  value = module.ecs_cluster.aws_security_group_ecs_cluster_asg
}

output "aws_ecs_capacity_provider" {
  value = module.ecs_cluster.aws_ecs_capacity_provider
}

output "repository_url" {
  value = module.ecs_cluster.repository_url
}
