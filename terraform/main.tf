# --- root/main.tf ---

module "networking" {
  source          = "./networking"
  vpc_cidr        = var.vpc_cidr
  vpc_name        = var.vpc_name
  private_subnets = var.private_subnets
}

module "lambda-api" {
  source = "./lambda-api"
  private_subnets = module.networking.private_subnets
  vpc_id          = module.networking.vpc_id
  image_uri = var.image_uri
}