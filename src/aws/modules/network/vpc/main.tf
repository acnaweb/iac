locals {
    len_private_subnets = length(var.private_subnets)
    len_public_subnets = length(var.public_subnets)
}

# ********************************************************************
# VPC 

resource "aws_vpc" "default" {
    cidr_block = var.vpc_cidr_block 
         
    tags = {
        Name = "${var.project_name}-${var.environment}-vpc"
    }  
}

# ********************************************************************
# Private Subnet

resource "aws_subnet" "private_subnets" {
    count = local.len_private_subnets

    vpc_id = aws_vpc.default.id

    cidr_block = element(var.private_subnets[*], count.index)  

    availability_zone = element(var.azs[*], count.index)

    tags = {
        Name = "${var.project_name}-${var.environment}-private-subnet-${count.index}"
    }  
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.default.id
    
    tags = {
        Name = "${var.project_name}-${var.environment}-private-route-table"
    } 
}

resource "aws_route_table_association" "private" {
    count = local.len_private_subnets
    
    subnet_id = element(aws_subnet.private_subnets[*].id, count.index)

    route_table_id = aws_route_table.private.id
}

# ********************************************************************
# Public Subnet

resource "aws_subnet" "public_subnets" {
    count = local.len_public_subnets

    vpc_id = aws_vpc.default.id

    cidr_block = element(var.public_subnets, count.index)

    availability_zone = element(var.azs, count.index)

    tags = {
        Name = "${var.project_name}-${var.environment}-public_subnets"
    }  
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.default.id
    
    tags = {
        Name = "${var.project_name}-${var.environment}-public-route-table"
    } 
}

resource "aws_route_table_association" "public" {
    count = local.len_public_subnets
    
    subnet_id = element(aws_subnet.public_subnets[*].id, count.index)

    route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "app" { 
    vpc_id = aws_vpc.default.id

    tags = {
        Name = "${var.project_name}-${var.environment}-igw"
    }  
}

resource "aws_route" "public_internet_gateway" {
    route_table_id = aws_route_table.public.id

    gateway_id = aws_internet_gateway.app.id

    destination_cidr_block = "0.0.0.0/0"
}

