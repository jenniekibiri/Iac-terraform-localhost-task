
#web subnet 1
resource "aws_subnet" "web-subnet-1" {
  vpc_id                  = aws_vpc.localhost_vpc.id
  cidr_block              = var.web_subnet1_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.avail_zone1
  tags = {
    Name : "${var.env_prefix}-localhost-web-subnet1"
  }

}