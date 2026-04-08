
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "app-"
  image_id      = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
#!/bin/bash

# Create simple HTTP server WITHOUT installing anything
mkdir -p /var/www/html
echo "Hello from Arunesh Dwivedi " > /var/www/html/index.html

# Run Python HTTP server (always available)
cd /var/www/html
nohup python3 -m http.server 80 &

EOF
)
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1
 
  health_check_type         = "ELB"
  health_check_grace_period = 300 
  
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
}
