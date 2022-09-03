

resource "aws_instance" "web-server" {
  count = 20
  ami                         = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.web-subnet-1.id
  availability_zone           = var.avail_zone1
  key_name                    = aws_key_pair.ssh-key.key_name
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker 
sudo usermod -aG docker ec2-user
sudo docker pull jennykibiri/multicontainer-clientimage:latest
sudo docker run  -d -p 3000:3000 jennykibiri/multicontainer-clientimage:latest
EOF
  tags = {
    Name = "${var.env_prefix}-localhost-web-server-${count.index}"
  }
}




