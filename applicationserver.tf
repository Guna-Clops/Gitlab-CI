# Create the application servers
resource "aws_instance" "application_server_1" {
  ami           = "ami-0b9ecf71fe947bbdd"  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type
  subnet_id     = aws_subnet.public_subnet_1.id

  key_name      = "sonar"  # Replace with the name of your key pair

  vpc_security_group_ids = [aws_security_group.alb_sg.id]
  
  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y mysql-client
    echo "[client]
    host=${aws_db_instance.mysql_instance.endpoint}
    user=my_username
    password=my_password" > /root/.my.cnf
  EOF

  tags = {
    Name = "ApplicationServer1"
  }
}

resource "aws_instance" "application_server_2" {
  ami           = "ami-0b9ecf71fe947bbdd"  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type
  subnet_id     = aws_subnet.public_subnet_1.id

  key_name      = "sonar"  # Replace with the name of your key pair

  vpc_security_group_ids = [aws_security_group.alb_sg.id]
 
  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y mysql-client
    echo "[client]
    host=${aws_db_instance.mysql_instance.endpoint}
    user=my_username
    password=my_password" > /root/.my.cnf
  EOF

  tags = {
    Name = "ApplicationServer2"
  }
}

# Register the application servers with the target group
resource "aws_lb_target_group_attachment" "attachment_1" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.application_server_1.id
  port             = 80  # Example port 80 for HTTP traffic, adjust as needed
}

resource "aws_lb_target_group_attachment" "attachment_2" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.application_server_2.id
  port             = 80  # Example port 80 for HTTP traffic, adjust as needed
}