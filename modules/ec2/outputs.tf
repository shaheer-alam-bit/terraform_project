output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "metabase_public_ip" {
  value = aws_instance.amazon_linux_2_instance.public_ip
  description = "The public IP address of the Metabase instance"
}