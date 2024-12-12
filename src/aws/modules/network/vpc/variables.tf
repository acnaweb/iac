variable "project_name" {}
variable "environment" {}

variable "vpc_cidr_block" {
}

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