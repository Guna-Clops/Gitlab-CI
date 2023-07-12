resource "aws_security_group" "bastion_sg" {
  name        = "BastionSecurityGroup"
  description = "Security group for bastion host"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "BastionSecurityGroup"
  }
}

# Create the ALB security group allowing incoming traffic on desired ports
resource "aws_security_group" "alb_sg" {
  name        = "ALBSecurityGroup"
  description = "Security group for ALB"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80  # Example port 80 for HTTP traffic, adjust as needed
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443  # Example port 443 for HTTPS traffic, adjust as needed
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306  # Example port 80 for HTTP traffic, adjust as needed
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALBSecurityGroup"
  }
}

# Create a security group for the database
resource "aws_security_group" "db_sg" {
  name        = "DBSecurityGroup"
  description = "Security group for the database"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306  # MySQL port
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DBSecurityGroup"
  }
}