# Create a private subnet for RDS instances
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "172.31.144.0/20" # First private CIDR block
  availability_zone       = "us-east-1a"     # First AZ

  tags = {
    Name = "Private Subnet 1 for RDS"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = var.vpc_id
  cidr_block              = "172.31.128.0/20" # Second private CIDR block
  availability_zone       = "us-east-1b"      # Second AZ

  tags = {
    Name = "Private Subnet 2 for RDS"
  }
}


# RDS MySQL Instance
resource "aws_db_instance" "mysql_instance" {
  identifier              = "mysql-rds-instance"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.mysql_db_name
  username                = var.mysql_username
  password                = var.mysql_password
  parameter_group_name    = "default.mysql8.0"
  publicly_accessible     = false
  skip_final_snapshot = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "MySQL RDS Instance"
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres_instance" {
  identifier              = "postgres-rds-instance"
  engine                  = "postgres"
  engine_version          = "17.2"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.postgres_db_name
  username                = var.postgres_username
  password                = var.postgres_password
  publicly_accessible     = false
  skip_final_snapshot = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "PostgreSQL RDS Instance"
  }
}

# Subnet Group for RDS Instances
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-private-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "RDS Subnet Group"
  }
}

