output "app_sg_id" {
  value = aws_security_group.app.id
}

output "lb_sg_id" {
  value = aws_security_group.lb.id
}