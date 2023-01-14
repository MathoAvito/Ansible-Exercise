module "network" {
  source = "./modules/network"
  ansible_hosts = module.compute.ansible_hosts
}

module "compute" {
  source = "./modules/compute"
  subnets = module.network.subnets
  security_groups = module.network.security_groups
  /* vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids */
}