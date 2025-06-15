resource "aws_instance" "amazon_linux_2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  security_groups = [var.sg-id]

  user_data = templatefile("${path.module}/userdata_metabase.sh", {
    DB_NAME = var.DB_NAME
    DB_USERNAME = var.DB_USERNAME
    DB_PASSWORD = var.DB_PASSWORD
    DB_ENDPOINT = var.DB_ENDPOINT
    DB_PORT = var.DB_PORT
  })

  tags = {
    Name = "Metabase-Instance"
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "al2023-launch-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
      DB_NAME     = var.DB_NAME
      DB_USERNAME = var.DB_USERNAME
      DB_PASSWORD = var.DB_PASSWORD
      DB_ENDPOINT = var.DB_ENDPOINT
      DB_PORT     = var.DB_PORT
    }))

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg-id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-instance"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2
  vpc_zone_identifier = [var.subnet_id]
  
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ASG-Instance"
    propagate_at_launch = true
  }
}
