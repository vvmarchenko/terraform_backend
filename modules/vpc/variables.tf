variable "cidr_block" {
  type        = string
  description = "CIDR block for your VPC"
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the public subnets"
}

variable "availability_zones" {
  description = "List of availability zones for the public subnets"
  type        = list(string)
}
variable "vpc_name" {
  description = "Choose your VPC name"
  type        = string
}

variable "region" {
  description = "Choose your AWS region name"
  type        = string
}

variable "destination_cidr_block" {
  default     = "0.0.0.0/0"
  description = "The destination CIDR block for your route tables"
  type        = string
}
