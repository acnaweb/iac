# # Configure the AWS Provider
# provider "aws" {
#   region = "us-east-1"
# }

resource "aws_security_group" "app" {
    name = "${var.project_name}-${var.environment}-app-sg"

    vpc_id = var.vpc_id
  
    tags = {
        Name = "${var.project_name}-${var.environment}-app-sg"
    }  

    # Opção para revogar regras de segurança ao deletar o grupo de segurança
    revoke_rules_on_delete = true

    description = "App security group"
}

resource "aws_security_group_rule" "app_ssh" {
    security_group_id = aws_security_group.app.id
    
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH connection"
}

resource "aws_security_group_rule" "all_ingress" {
    count = length(var.target_ports)

    security_group_id = aws_security_group.app.id    
    type = "ingress"
    protocol = "tcp"
    from_port = element(var.target_ports, count.index)
    to_port = element(var.target_ports, count.index)
    cidr_blocks = ["0.0.0.0/0"]
    description = "TCP connection port=${element(var.target_ports, count.index)}"       
}

resource "aws_security_group_rule" "app_outbound" {
    security_group_id = aws_security_group.app.id
    
    type = "egress"
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outbound all ports"

}