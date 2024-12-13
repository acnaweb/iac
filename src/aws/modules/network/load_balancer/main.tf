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

resource "aws_lb_target_group" "http" {
    name        = "${var.project_name}-${var.environment}-http"
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = var.vpc_id 
}

resource "aws_lb_target_group" "targets" {
    count = length(var.target_ports)
    name        = "${var.project_name}-${var.environment}-${var.target_ports[count.index]}"    
    port        = element(var.target_ports, count.index)
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = var.vpc_id 
}

resource "aws_lb_listener" "listeners" {
    count = length(var.target_ports)

    load_balancer_arn = aws_lb.default.arn
    port              = element(var.target_ports, count.index)
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = element(aws_lb_target_group.targets[*].arn, count.index)
    }
}
