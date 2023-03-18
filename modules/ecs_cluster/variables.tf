variable "capacity_provider_name" {
  description = "Name of the capacity provider"
  type        = string
}

variable "global_name" {
  description = "The global name for all project."
  type        = string
}

variable "desired_capacity" {
  type        = number
  default     = 1
  description = "Desired capacity for the autoscaling group"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Minimum size for the autoscaling group"
}

variable "max_size" {
  type        = number
  default     = 3
  description = "Maximum size for the autoscaling group"
}

variable "launch_template_name" {
  description = "Prefix for the name of the Launch Template"
  type        = string
}

variable "instance_type" {
  default     = "t2.micro"
  description = "The EC2 instance type to use for the Capacity Provider"
}

variable "vpc_id" {
  description = "VPC ID from is a vpc_module"
}

variable "subnet_id" {
  description = "subnet ID from is a vpc_module"
}

variable "region" {
  default = "us-east-1"
  type    = string
}
