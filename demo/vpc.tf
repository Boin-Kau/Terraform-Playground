resource "aws_vpc" "vpc_demo" {
    cidr_block = "192.168.0.0/16"

    tags = {
        Name = "VPC-DEMO-FOR-TF"
    }
}

resource "aws_subnet" "demo_public_subnet1" {
    vpc_id = aws_vpc.vpc_demo
    cidr_block = "192.168.1.0/24"

    availability_zone = "ap-northeast-2a"

    tags = {
      Name = "SUBNET-DEMO-PUBLIC-1"
    }
}

resource "aws_subnet" "demo_private_subnet1" {
  vpc_id = aws_vpc.vpc_demo
  cidr_block = "192.168.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "SUBNET-DEMO-PRIVATE-1"
  }
}