

# Create the bastion host in the public subnet
resource "aws_instance" "bastion_host" {
  ami           = "ami-0b9ecf71fe947bbdd"  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type
  subnet_id     = aws_subnet.public_subnet_1.id

  key_name      = "sonar"  # Replace with the name of your key pair

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "BastionHost"
  }
}