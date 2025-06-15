output "pg_db_name" {
  value = aws_db_instance.postgres_instance.db_name
  sensitive = true
}
output "pg_db_username" {
  value = aws_db_instance.postgres_instance.username
  sensitive = true
}
output "pg_db_password" {
  value = aws_db_instance.postgres_instance.password
  sensitive = true
}
output "pg_db_endpoint" {
  value = split(":", aws_db_instance.postgres_instance.endpoint)[0]
  sensitive = true
}
output "pg_db_port" {
  value = split(":", aws_db_instance.postgres_instance.endpoint)[1]
  sensitive = true
}
output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
  description = "Security Group ID for the EC2 instance"
}
