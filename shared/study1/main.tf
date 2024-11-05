resource "aws_security_group" "custom_security_group" {
  
  name = "custom_security_group"
  description = "Security Group EC2 Instance"

  ingress {

    description = "Inbound Rule"
    from_port = 22
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    description = "Outbound Rule"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    }
}

resource "aws_instance" "instance_user_data" {
  count = 2
  
  ami = "ami-0a0d9cf81c479446a"  
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.custom_security_group.id]
  
  tags = {
    Name = "instance-user-data-${count.index}"
  }
  
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              sudo bash -c 'echo $(hostname -f) > /var/www/html/index.html'
              EOF

}

resource "aws_instance" "instance_scripts" {
  count = 1
  
  ami = "ami-0a0d9cf81c479446a"  
  
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.custom_security_group.id]
  
  key_name = "ec2-us-east-2"

  tags = {
    Name = "instance-scripts-${count.index}"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("/shared/secrets/ec2-us-east-2.pem")
    host     = self.public_ip
  }

  provisioner "file" {
    source      = "scripts/install_http.sh"
    destination = "/tmp/install_http.sh"
  }

  provisioner "remote-exec" {    
    inline = ["chmod +x /tmp/install_http.sh", "/tmp/install_http.sh"]   
  }

}
