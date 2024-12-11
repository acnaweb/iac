# module "storage" {
#     source = "../../modules/storage/marketmining-public"  
# }


module "network" {
    source = "../../modules/network/vpc"     
    project_name = var.project_name
    environment = var.environment
    azs = var.azs
    vpc_cidr_block = var.vpc_cidr_block
    private_subnets = var.private_subnets
}



module "security-group" {
    source = "../../modules/network/security_group"

    depends_on = [ module.network ] 
    project_name = var.project_name
    environment = var.environment
    vpc_id = module.network.vpc_id
}
