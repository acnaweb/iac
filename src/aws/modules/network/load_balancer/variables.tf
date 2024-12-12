variable "project_name" {}
variable "environment" {}
variable "security_group_id" {}
variable "public_subnets" {
    type = list(any)
}