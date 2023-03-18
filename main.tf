provider "aws" {
  profile = var.profile_name
  region  = var.region
  default_tags {
    tags = {
      Environment = "production"
      Owner       = "Vladyslav Marchenko"
      Project     = "conduit"
    }
  }
}

module "vpc" {
  source                    = "./modules/vpc"
  region                    = var.region
  cidr_block                = var.cidr_block
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  availability_zones        = var.availability_zones
  vpc_name                  = var.vpc_name
}


module "ecs_cluster" {
  source                 = "./modules/ecs_cluster"
  global_name            = var.global_name
  capacity_provider_name = var.capacity_provider_name
  launch_template_name   = var.launch_template_name
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.subnet_id
}


module "ecs_service" {
  source                             = "./modules/ecs_service"
  global_name                        = var.global_name
  resource_name                      = var.resource_name
  vpc_id                             = module.vpc.vpc_id
  subnet_id                          = module.vpc.subnet_id
  cluster_id                         = module.ecs_cluster.cluster_id
  aws_ecs_capacity_provider          = module.ecs_cluster.aws_ecs_capacity_provider
  repository_url                     = module.ecs_cluster.repository_url
}
