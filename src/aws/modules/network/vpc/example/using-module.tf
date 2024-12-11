# Define VPC usando o módulo terraform-aws-modules/vpc/aws
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc-marketmining" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  # Nome da VPC e CIDR block
  name = "${var.project_name}-default-vpc"
  cidr = var.vpc_cidr_block

  # Zonas de disponibilidade 
  azs = var.azs
  # public_subnets  = [var.public_subnet_1_cidr_block, var.public_subnet_2_cidr_block]

  private_subnets = var.private_subnets

  # # Tag para cada recurso na VPC
  private_subnet_tags         = { Name = "${var.project_name}-${var.environment}-private-subnet" }

  # public_subnet_tags          = { Name = "${var.project_name}-${var.env}-public-subnet" }
  # igw_tags                    = { Name = "${var.project_name}-${var.env}-igw" }
  # default_security_group_tags = { Name = "${var.project_name}-${var.env}-default-sg" }
  # default_route_table_tags    = { Name = "${var.project_name}-${var.env}-main-rtb" }
  # public_route_table_tags     = { Name = "${var.project_name}-${var.env}-public-rtb" }

  # Tag da VPC
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }

  
}