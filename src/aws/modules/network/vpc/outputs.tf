output "vpc_id" {
    value = aws_vpc.default.id  
}

output "public_subnets" {
    value = aws_subnet.subnets
}