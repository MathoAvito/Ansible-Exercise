module "network" {
  source = "./modules/network"
  ansible_hosts = module.compute.ansible_hosts
}

module "compute" {
  source = "./modules/compute"
  subnets = module.network.subnets
  security_groups = module.network.security_groups
}