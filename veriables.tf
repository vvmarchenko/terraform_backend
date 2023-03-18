variable "profile_name" {
  default = "default"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "launch_template_name" {
  default     = "coduit_launch_template"
  description = "Prefix for the name of the Launch Template"
  type        = string
}

variable "capacity_provider_name" {
  default     = "conduit_capacity"
  description = "Name of the capacity provider"
  type        = string
}

variable "global_name" {
  default     = "conduit-backend"
  type        = string
  description = "The global name for all project."
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for your VPC"
}

variable "public_subnet_cidr_blocks" {
  default = {
    "public_subnet1" = "10.0.1.0/24"
    "public_subnet2" = "10.0.2.0/24"
  }
  description = "List of CIDR blocks for the public subnets"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_name" {
  default     = "conduit_vpc"
  description = "Choose your VPC name"
  type        = string
}

variable "destination_cidr_block" {
  default     = "0.0.0.0/0"
  description = "The destination CIDR block for your route tables"
  type        = string
}

variable "resource_name" {
  default     = "hillel/conduit/db"
  type        = string
  description = "The recource name from your parameter store."
}
