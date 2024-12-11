
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




resource "aws_instance" "dsa_ml_api" {

  ami = "ami-0a0d9cf81c479446a"  

  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name

  vpc_security_group_ids = [aws_security_group.dsa_ml_api_sg.id]

  # Script de inicialização
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y python3 python3-pip awscli
                sudo pip3 install flask joblib scikit-learn numpy scipy gunicorn
                sudo mkdir /opt/app
                sudo aws s3 sync s3://market-mining-dsa-curso /opt/app
                cd /opt/app
                nohup gunicorn -w 4 -b 0.0.0.0:5000 app:app &
              EOF


  tags = {
    Name = "FlaskApp"
  }
}
