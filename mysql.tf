
# Create the DB subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name    = "subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]  # Replace with the correct private subnet IDs
}

# Create the MySQL RDS instance
resource "aws_db_instance" "mysql_instance" {
  identifier            = "mydbb-new"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t2.micro"
  allocated_storage     = 20
  storage_type          = "gp2"
  publicly_accessible  = false
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az              = false
  username              = "mysqluser"
  password              = "!AdLor!1234"
  
  tags = {
    Name = "database"
  }
}