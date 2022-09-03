// route table for the internet gateway
resource "aws_route_table" "web-rtb" {
  #which VPC this route table belongs to
  vpc_id = aws_vpc.localhost_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.localhost_igw.id

  }
  tags = {
    Name : "${var.env_prefix}-web-rtb"
  }

}

resource "aws_route_table_association" "a-rtb-web-subnet1" {
  subnet_id      = aws_subnet.web-subnet-1.id
  route_table_id = aws_route_table.web-rtb.id

}


