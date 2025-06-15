# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow internal and application-specific access"
  
  # Allow SSH access from your IP
  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP access for internal communication
  ingress {
    description = "Allow HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS access for internal communication
  ingress {
    description = "Allow HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Security Group"
  }
}


# Security Group for RDS Instances
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow only EC2 access via SSH tunnel"
  vpc_id      = var.vpc_id

  # MySQL access from EC2 instances
  ingress {
    description      = "MySQL access from EC2 instances"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  # PostgreSQL access from EC2 instances
  ingress {
    description      = "PostgreSQL access from EC2 instances"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  # Allow all egress traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}
