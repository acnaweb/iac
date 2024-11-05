output "instance_user_data_public_ip" {
  value = aws_instance.instance_user_data.*.public_ip
}

output "instance_instance_scripts" {
  value = aws_instance.instance_scripts.*.public_ip
}
