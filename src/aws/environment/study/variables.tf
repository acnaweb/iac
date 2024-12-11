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

variable "vpc_cidr_block" {
}

variable "private_subnets" {
  type = list(string) 
  default = [""] 
}

variable "azs" {
  description = "Availability zones"
  type = list(string)   
}

