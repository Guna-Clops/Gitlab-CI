# Create the ALB
resource "aws_lb" "my_alb" {
  name               = "MyALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]  # Replace with your desired subnets

  tags = {
    Name = "MyALB"
  }
}


# Create the target group for the application servers
resource "aws_lb_target_group" "my_target_group" {
  name     = "Mytest"
  port     = 80  # Example port 80 for HTTP traffic, adjust as needed
  protocol = "HTTP"

  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyTargetGroup"
  }
}
