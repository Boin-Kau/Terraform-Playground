resource "aws_vpc" "vpc_demo" {
    cidr_block = "192.168.0.0/16"

    tags = {
        Name = "VPC-DEMO-FOR-TF"
    }
}

resource "aws_subnet" "demo_public_subnet1" {
    vpc_id = aws_vpc.vpc_demo.id
    cidr_block = "192.168.1.0/24"

    availability_zone = "ap-northeast-2a"

    tags = {
      Name = "SUBNET-DEMO-PUBLIC-1"
    }
}

resource "aws_subnet" "demo_private_subnet1" {
  vpc_id = aws_vpc.vpc_demo.id
  cidr_block = "192.168.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "SUBNET-DEMO-PRIVATE-1"
  }
}

resource "aws_internet_gateway" "igw_demo" {
  vpc_id = aws_vpc.vpc_demo.id

  tags = {
    Name = "IGW-DEMO"
  }  
}

resource "aws_eip" "eip_nat_demo" {
  vpc = true
  
  lifecycle {
    create_before_destroy = true
  } 
}

resource "aws_nat_gateway" "nat_gateway_demo" {
  allocation_id = aws_eip.eip_nat_demo.id

  subnet_id = aws_subnet.demo_public_subnet1.id 

  tags = {
    Name = "NAT-GW-DEMO"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc_demo.id

  tags = {
    Name = "RTB-DEMO-PUBLIC"
  }
  
}

resource "aws_route_table_association" "rtb_association_public" {
  subnet_id = aws_subnet.demo_public_subnet1.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table" "rtb_private" {
  vpc_id = aws_vpc.vpc_demo.id

  tags = {
    Name = "RTB-DEMO-PRIVATE"
  } 
}

resource "aws_route_table_association" "rtb_association_private" {
  subnet_id = aws_subnet.demo_private_subnet1.id
  route_table_id = aws_route_table.rtb_private.id
}

resource "aws_route" "public_nat" {
  route_table_id = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_demo.id
  
}

resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.rtb_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway_demo.id
  
}
