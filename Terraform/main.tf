module "network" {
  source = "./modules/network"
}

module "compute" {
  source = "./modules/compute"
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
}