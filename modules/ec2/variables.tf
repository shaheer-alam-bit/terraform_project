variable "sg-id" {
    description = "The security group ID to associate with the EC2 instances."
    type        = string
}

variable "ami_id" {
    description = "The AMI ID to use for the EC2 instances."
    type        = string
    default     = "ami-0e9bbd70d26d7cf4f"
}
variable "instance_type" {
    description = "The type of instance to use for the EC2 instances."
    type        = string
    default     = "t2.micro"
}
variable "key_name" {
    description = "The name of the key pair to use for SSH access to the EC2 instances."
    type        = string
    default     = "project_key"
}
variable "subnet_id" {
    description = "The subnet IDs to launch the EC2 instances in."
    type        = string
    default     = "subnet-00374fab71138361e"
}
variable "ec2_name" {
    description = "The name tag for the EC2 instances."
    type        = string
    default     = "ec2-instance"
}
variable "DB_NAME" {
    description = "The name of the database to connect to."
    type        = string
}
variable "DB_USERNAME" {
    description = "The username for the database."
    type        = string
}
variable "DB_PASSWORD" {
    description = "The password for the database."
    type        = string
}
variable "DB_ENDPOINT" {
    description = "The endpoint of the database."
    type        = string
}
variable "DB_PORT" {
    description = "The port of the database."
    type        = number
    default     = 5432
}