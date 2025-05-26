provider "aws" {
  region = var.region
}

resource "random_id" "suffix" {
  byte_length = 4
}

#---------- Modules ----------#
module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = "10.0.0.0/16"
  azs        = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "wiki-attachments-${random_id.suffix.hex}"
}

module "rds" {
  source          = "./modules/rds"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  db_username     = var.db_username
  ecs_sg_id       = module.ecs.ecs_sg_id
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  acm_cert_arn   = var.acm_cert_arn
}

module "ecs" {
  source           = "./modules/ecs"
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  alb_target_group_arn = module.alb.target_group_arn
  db_host          = module.rds.db_endpoint
  db_username      = var.db_username
  db_password_arn  = module.rds.db_password_arn
  s3_bucket_name   = module.s3.bucket_name
  alb_sg_id        = module.alb.alb_sg_id
}

module "monitoring" {
  source           = "./modules/monitoring"
  ecs_cluster_name = module.ecs.ecs_cluster_name
  alb_arn          = module.alb.alb_arn
  rds_instance_id  = module.rds.db_instance_id
}