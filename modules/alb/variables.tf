variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
  default     = "vpc-0fe9b750f15e1b9f0"
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}