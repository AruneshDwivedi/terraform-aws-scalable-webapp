terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
}
module "alb" {
  source         = "../../modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}
module "compute" {
  source           = "../../modules/compute"
  private_subnets  = module.vpc.private_subnets
  target_group_arn = module.alb.tg_arn
  vpc_id           = module.vpc.vpc_id
  alb_sg_id        = module.alb.alb_sg_id
}
module "rds" {
  source          = "../../modules/rds"
  private_subnets = module.vpc.private_subnets
}
