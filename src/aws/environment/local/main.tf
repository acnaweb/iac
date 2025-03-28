module "storage" {
    source = "../../modules/storage"  

    project_name = var.project_name
    environment = var.environment
}


module "vpc" {
    source = "../../modules/network/vpc"  

    project_name = var.project_name
    environment = var.environment
    azs = var.azs
    vpc_cidr_block = var.vpc_cidr_block
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
}

module "security-group" {
    source = "../../modules/network/security_group"

    depends_on = [ module.vpc ] 
    project_name = var.project_name
    environment = var.environment
    vpc_id = module.vpc.vpc_id
    target_ports = var.target_ports  

}

module "load-balancer" {
    source = "../../modules/network/load_balancer"  
    depends_on = [ module.security-group, module.vpc ]

    project_name = var.project_name
    environment = var.environment
    vpc_id = module.vpc.vpc_id
    public_subnets = module.vpc.public_subnets
    security_group_id = module.security-group.lb_sg_id
    target_ports = var.target_ports  
}

module "ecs" {
    source = "../../modules/container/ecs"
    depends_on = [ module.security-group, module.vpc ]

    project_name = var.project_name
    environment = var.environment
}