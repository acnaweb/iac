# Define VPC usando o módulo terraform-aws-modules/vpc/aws
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  # Nome da VPC e CIDR block
  name = "vpc-module"
  cidr = var.vpc_cidr_block

  # Zonas de disponibilidade e subnets
  azs             = [var.azs[0], var.azs[1]]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  # Tag para cada recurso na VPC
  private_subnet_tags         = { Name = "${var.project_name}-${var.environment}-private-subnet" }
  public_subnet_tags          = { Name = "${var.project_name}-${var.environment}-public-subnet" }
  igw_tags                    = { Name = "${var.project_name}-${var.environment}-igw" }
  default_security_group_tags = { Name = "${var.project_name}-${var.environment}-default-sg" }
  default_route_table_tags    = { Name = "${var.project_name}-${var.environment}-main-rtb" }
  public_route_table_tags     = { Name = "${var.project_name}-${var.environment}-public-rtb" }

  # Tag da VPC
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc-module"
  }
}