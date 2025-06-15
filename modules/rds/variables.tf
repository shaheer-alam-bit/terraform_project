variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
  default     = "vpc-0fe9b750f15e1b9f0"
}

variable "mysql_db_name" {
  description = "Name of the MySQL database"
  type        = string
  default     = "mysql_db"
}

variable "mysql_username" {
  description = "MySQL username"
  type        = string
  default     = "mysqladmin"
}

variable "mysql_password" {
  description = "MySQL password"
  type        = string
  default = "admin1234"
}

variable "postgres_db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "pgdb"
}

variable "postgres_username" {
  description = "PostgreSQL username"
  type        = string
  default     = "postgresadmin"
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "admin1234"
}
