provider "aws" {
    region = "eu-north-1"
}

module "network" {
    source = "../../modules/network"
    env_name = "prod"
    vpc_cidr = "10.0.0.0/16"
    private_subnet_cidr = "10.0.1.0/24"
    public_subnet_cidr = "10.0.60.0/24"
}

module "compute" {
    source = "../../modules/compute"
    vpc_id = module.network.main_vpc_id
    subnet_id = module.network.private_subnet_id
}