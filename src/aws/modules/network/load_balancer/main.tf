resource "aws_lb" "default" {
    name = "${var.project_name}-${var.environment}-lb"

    internal = false

    load_balancer_type = "application"

    security_groups = [var.security_group_id]
    subnets = [for subnet in var.public_subnets : subnet.id]

    tags = {
        Name = "${var.project_name}-${var.environment}-lb"
    }  
}