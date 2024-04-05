# VPC
module "vpc" {
  source = "./modules/networking"

  vpc_name             = var.vpc_name
  vpc_cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

}

# Security
module "security" {
  source = "./modules/security"

  vpc_id      = module.vpc.vpc_id
  allowed_ips = var.allowed_ips

}

# DynamoDB Databases
module "databases" {
  source = "./modules/databases"

  table_names   = var.table_names
  hash_key      = var.hash_key
  hash_key_type = var.hash_key_type
}

# Servers
module "app-servers" {
  source = "./modules/app-servers"

  public_subnet_id  = module.vpc.public_subnet_ids
  private_subnet_id = module.vpc.private_subnet_ids

  bastion_sg = [module.security.bastion_sg_id]
  public_sg  = [module.security.public_sg_id]
  private_sg = [module.security.private_sg_id]
}
