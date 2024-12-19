variable "project_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "public_subnets" {
    type = list(any)
}
variable "security_group_id" {}

