resource "aws_security_group" "lb" {
    name = "${var.project_name}-${var.environment}-lb-sg"

    vpc_id = var.vpc_id
  
    tags = {
        Name = "${var.project_name}-${var.environment}-lb-sg"
    }  

    # Opção para revogar regras de segurança ao deletar o grupo de segurança
    revoke_rules_on_delete = true

    description = "Load Balance security group"
}

resource "aws_security_group_rule" "lb_ssh" {
    security_group_id = aws_security_group.lb.id
    
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH connection"
}

resource "aws_security_group_rule" "lb_http" {
    security_group_id = aws_security_group.lb.id
    
    type = "ingress"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Http connection"       
}

resource "aws_security_group_rule" "lb_https" {
    security_group_id = aws_security_group.lb.id
    
    type = "ingress"
    protocol = "tcp"
    from_port = 81
    to_port = 81
    cidr_blocks = ["0.0.0.0/0"]
    description = "Https connection"       
}

resource "aws_security_group_rule" "lb_outbound" {
    security_group_id = aws_security_group.lb.id
    
    type = "egress"
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outbound all ports"

}