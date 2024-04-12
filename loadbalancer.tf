# Upload SSL certificate to AWS Certificate Manager
resource "aws_acm_certificate" "my_certificate" {
  domain_name       = "venflare.com" # Replace with your domain name
}

# Create listener with SSL certificate
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.my_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_80.arn # Replace with your target group ARN
  }
}


resource "aws_lb" "my_load_balancer" {
  name               = "ticket-egypt-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mySG.id]
  subnets            = [aws_subnet.my_subnet.id]
  ip_address_type    = "ipv4"
  

  # Define any additional settings for your load balancer as needed
}




# Create target group for port 80
resource "aws_lb_target_group" "target_group_80" {
  name        = "target-group-80"
  port        = 80
  protocol    = "HTTP"
  vpc_id =     aws_vpc.myvpc.id
  target_type = "instance"
  # Additional attributes can be added if needed
}

# Create target group for port 5001
resource "aws_lb_target_group" "target_group_5001" {
  name        = "target-group-5001"
  port        = 5001
  protocol    = "HTTP"
  vpc_id = aws_vpc.myvpc.id
  target_type = "instance"
  # Additional attributes can be added if needed
}

# Attach target groups to the load balancer
resource "aws_lb_listener" "listener_80" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_80.arn
  }
}

resource "aws_lb_listener" "listener_5001" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = 5001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_5001.arn
  }
}