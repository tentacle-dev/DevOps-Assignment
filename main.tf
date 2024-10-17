# 1. Specify the provider (AWS in this case)
provider "aws" {
  region = "us-east-1"  # Change this to your preferred region
}

# 2. Create a security group for the EC2 instance and load balancer
resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = "vpc-xxxxxxx"  # Replace with your VPC ID
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = "ami-xxxxxxx"  # Replace with an appropriate Amazon Machine Image (AMI) ID
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_web_traffic.name]
  
  tags = {
    Name = "WebServerInstance"
  }
}

# 4. Create a load balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web_traffic.id]
  subnets            = ["subnet-xxxxxxx", "subnet-yyyyyyy"]  # Replace with your subnet IDs

  enable_deletion_protection = false
}

# 5. Create a target group for the load balancer
resource "aws_lb_target_group" "app_lb_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-xxxxxxx"  # Replace with your VPC ID
}

# 6. Create a listener for the load balancer
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
  }
}
