variable "global_name" {
  description = "The global name for all project."
  type        = string
}

variable "tg_port" {
  type        = number
  default     = 4000
  description = "Port to use for the target group"
}

variable "container_port" {
  default     = 4000
  type        = number
  description = "Port for your container."
}

variable "vpc_id" {
  description = "VPC ID from is a vpc_module"
}

variable "subnet_id" {
  description = "subnet ID from is a vpc_module"
}

variable "cluster_id" {
  description = "The cluster ID from ecs_cluster module"
  type        = string
}

variable "aws_ecs_capacity_provider" {
  description = "The capacity provider from ecs_cluster module"
}

variable "repository_url" {
  description = "The URL for ecr repo from ecs_cluster module"
}

variable "resource_name" {
  type        = string
  description = "The recource name from your parameter store."
}
