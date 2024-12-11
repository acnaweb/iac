# # Configure the AWS Provider
# provider "aws" {
#   region = "us-east-1"
# }

resource "aws_vpc" "default" {
    cidr_block = var.vpc_cidr_block 

     
    tags = {
        Name = "${var.project_name}-${var.environment}-vpc"
    }  
}

resource "aws_route_table" "default" {
    vpc_id = aws_vpc.default.id
    
    tags = {
        Name = "${var.project_name}-${var.environment}-route-table"
    } 
}

resource "aws_subnet" "subnets" {
    count = length(var.private_subnets)

    vpc_id = aws_vpc.default.id

    cidr_block = var.private_subnets[count.index]  

    availability_zone = var.azs[count.index]

    tags = {
        Name = "${var.project_name}-${var.environment}-subnet"
    }  
}


resource "aws_route_table_association" "subnets" {
    count = length(var.private_subnets)
    
    route_table_id = aws_route_table.default.id

    subnet_id = aws_subnet.subnets[count.index].id

}

resource "aws_internet_gateway" "default" { 
    vpc_id = aws_vpc.default.id

    tags = {
        Name = "${var.project_name}-${var.environment}-igw"
    }  
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.default.id

    gateway_id = aws_internet_gateway.default.id

    destination_cidr_block = "0.0.0.0/0"
}

