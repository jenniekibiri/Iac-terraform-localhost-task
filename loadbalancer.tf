


resource "aws_lb" "external-elb" {
  name               = "${var.env_prefix}-localhost-external-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.web-subnet-1.id]
  security_groups    = [aws_security_group.loadbalancer-sg.id]
}

//attach load balancer to web servers
resource "aws_lb_target_group" "external-elb" {
  name     = "ALB-TG"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.localhost_vpc.id
}

//listens on port 80 and redirects to target group
resource "aws_lb_listener" "external-elb" {
  load_balancer_arn = aws_lb.external-elb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external-elb.arn
  }
}
