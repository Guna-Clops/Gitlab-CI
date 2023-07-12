resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "testvpc"
  }
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"  # Replace with your desired availability zone
  tags = {
    Name = "PublicSubnet1"
  }
}

# Create the second public subnet
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"  # Replace with your desired availability zone
  tags = {
    Name = "PublicSubnet2"
  }
}

# Create the first private subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1c"  # Replace with your desired availability zone
  tags = {
    Name = "PrivateSubnet1"
  }
}

# Create the second private subnet
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1a"  # Replace with your desired availability zone
  tags = {
    Name = "PrivateSubnet2"
  }
}

# Create the internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

# Create the private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "PrivateRouteTable"
  }
}

# Create the public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "PublicRouteTable"
  }
}

# Create a route in the public route table for internet gateway
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create the NAT gateway
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

# Create a route in the private route table for the NAT gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id
}
# Associate the public route table with the public subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}


# Associate the private route table with the private subnets

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create an Elastic IP for the NAT gateway
resource "aws_eip" "my_eip" {
  vpc = true
}