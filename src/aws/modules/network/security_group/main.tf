# # Configure the AWS Provider
# provider "aws" {
#   region = "us-east-1"
# }

resource "aws_security_group" "default" {
    name = "${var.project_name}-${var.environment}-security-group"

    vpc_id = var.vpc_id
  
    tags = {
        Name = "${var.project_name}-${var.environment}-security-group"
    }  

    # Opção para revogar regras de segurança ao deletar o grupo de segurança
    revoke_rules_on_delete = true

    description = "Custom security group"
}

resource "aws_security_group_rule" "ssh" {
    security_group_id = aws_security_group.default.id
    
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH connection"
}

resource "aws_security_group_rule" "http" {
    security_group_id = aws_security_group.default.id
    
    type = "ingress"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Http connection"       
}

resource "aws_security_group_rule" "https" {
    security_group_id = aws_security_group.default.id
    
    type = "ingress"
    protocol = "tcp"
    from_port = 81
    to_port = 81
    cidr_blocks = ["0.0.0.0/0"]
    description = "Https connection"       
}

resource "aws_security_group_rule" "all-egress" {
    security_group_id = aws_security_group.default.id
    
    type = "egress"
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outbound all ports"

}