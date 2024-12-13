variable "project_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "target_ports" {
    type = list(number)
}