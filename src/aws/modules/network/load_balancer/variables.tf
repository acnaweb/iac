variable "project_name" {}
variable "environment" {}
variable "security_group_id" {}
variable "vpc_id" {}
variable "public_subnets" {
    type = list(any)
}
variable "target_ports" {
    type = list(number)
}