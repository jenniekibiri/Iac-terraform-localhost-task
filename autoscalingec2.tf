//launch config to be used by autoscaling group to launch 6 ec2 instances


resource "aws_launch_configuration" "web-server-launch-config" {
  name_prefix                 = "${var.env_prefix}-web-server-launch-config"
  image_id                    = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh-key.key_name
  security_groups             = [aws_security_group.web-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker 
sudo usermod -aG docker ec2-user
sudo docker pull jennykibiri/multicontainer-clientimage:latest
sudo docker run  -d -p 3000:3000 jennykibiri/multicontainer-clientimage:latest
EOF
}

//autoscaling group to launch 6 ec2 instances
resource "aws_autoscaling_group" "web-server-asg" {
  name                      = "${var.env_prefix}-web-server-asg"
  max_size                  = 6
  min_size                  = 6
  desired_capacity          = 6
  launch_configuration      = aws_launch_configuration.web-server-launch-config.name
  vpc_zone_identifier       = [aws_subnet.web-subnet-1.id]
  health_check_grace_period = 300
  tag {
    key                 = "Name"
    value               = "${var.env_prefix}-web-server-asg"
    propagate_at_launch = true
  }


}
//auootscaling policy to scale up the asg
resource "aws_autoscaling_policy" "web-server-asg-scale-up-policy" {
  name                   = "${var.env_prefix}-web-server-asg-scale-up-policy"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web-server-asg.name
}

