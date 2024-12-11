variable "project_name" {}
variable "environment" {}

variable "vpc_cidr_block" {
}

variable "azs" {
  description = "Availability zones"
  type = list(string)  
}

variable "private_subnets" {
  type = list(string)  
}