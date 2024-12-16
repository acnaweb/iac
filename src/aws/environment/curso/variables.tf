# Credentials

variable "aws_access_key" {}
variable "aws_secret_key" {}

# Generics

variable "aws_region" {}
variable "project_name" {}
variable "environment" {}
variable "common_tags" {
  type = map(string)  
}

# Network

variable "vpc_cidr_block" {}

variable "private_subnets" {
  type = list(string) 
}

variable "public_subnets" {
  type = list(string) 
}

variable "azs" {
  description = "Availability zones"
  type = list(string)   
}

variable "target_ports" {
    type = list(number)
}
