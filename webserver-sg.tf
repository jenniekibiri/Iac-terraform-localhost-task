
# Create Web Server Security Group
resource "aws_security_group" "web-sg" {
  name        = "Web-SG"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.localhost_vpc.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip, var.jenkins_server]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "${var.env_prefix}-localhost-web-sg"
  }
}
