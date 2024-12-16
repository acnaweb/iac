# ********************************************************************
# Variables

locals {
    len_private_subnets = length(var.private_subnets)

    len_public_subnets = length(var.public_subnets)

    create_private_subnet = length(var.private_subnets) > 0

    create_public_subnet = length(var.public_subnets) > 0
}

# ********************************************************************
# VPC 

resource "aws_vpc" "default" {
    cidr_block = var.vpc_cidr_block 
    enable_dns_hostnames = true
    enable_dns_support = true
         
    tags = {
        Name = "${var.project_name}-${var.environment}-vpc"
    }  
}

# ********************************************************************
# Private Subnet

resource "aws_subnet" "private_subnets" {
    count = local.create_private_subnet ? local.len_private_subnets : 0

    vpc_id = aws_vpc.default.id

    cidr_block = element(var.private_subnets[*], count.index)  

    availability_zone = element(var.azs[*], count.index)

    tags = {
        Name = "${var.project_name}-${var.environment}-private-subnet-${count.index}"
    }  
}

resource "aws_route_table" "private" {
    count = local.create_private_subnet ? 1 : 0

    vpc_id = aws_vpc.default.id
    
    tags = {
        Name = "${var.project_name}-${var.environment}-private-route-table"
    } 
}

resource "aws_route_table_association" "private" {
    count = local.create_private_subnet ? local.len_private_subnets : 0
    
    subnet_id = element(aws_subnet.private_subnets[*].id, count.index)

    route_table_id = aws_route_table.private[0].id
}

# ********************************************************************
# Public Subnet

resource "aws_subnet" "public_subnets" {
    count = local.create_public_subnet ? local.len_public_subnets : 0

    vpc_id = aws_vpc.default.id

    cidr_block = element(var.public_subnets, count.index)

    availability_zone = element(var.azs, count.index)

    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-${var.environment}-public_subnets"
    }  
}

resource "aws_route_table" "public" {
    count = local.create_public_subnet ? 1 : 0

    vpc_id = aws_vpc.default.id
    
    tags = {
        Name = "${var.project_name}-${var.environment}-public-route-table"
    } 
}

resource "aws_route_table_association" "public" {
    count = local.create_public_subnet ? local.len_public_subnets : 0
    
    subnet_id = element(aws_subnet.public_subnets[*].id, count.index)

    route_table_id = aws_route_table.public[0].id
}

resource "aws_internet_gateway" "app" { 
    count = local.create_public_subnet ? 1 : 0

    vpc_id = aws_vpc.default.id

    tags = {
        Name = "${var.project_name}-${var.environment}-igw"
    }  
}

resource "aws_route" "public_internet_gateway" {
    route_table_id = aws_route_table.public[0].id

    gateway_id = aws_internet_gateway.app[0].id

    destination_cidr_block = "0.0.0.0/0"
}

