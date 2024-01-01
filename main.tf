provider "aws" {
  region = "us-east-1"
  access_key = "AKIA5XPY4PPSUVJPGIP6"
  secret_key = "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"
  
}

resource "aws_iam_user" "user"{
  name = "terraform-cs423_devops_4"
}

resource "aws_iam_user_policy_attachment" "admin_policy" {
  user = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  
}

resource "aws_iam_access_key" "access-key"{
  user = aws_iam_user.user.name
}

resource "aws_vpc" "devops_assignment_4" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "devops-assignment-4"
  }
}

resource "aws_subnet" "public_1" {
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.devops_assignment_4.id
  map_public_ip_on_launch = true
  tags = {
    Name = "cs423-devops-public-1"
  }
}

resource "aws_subnet" "public_2" {
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.devops_assignment_4.id
  map_public_ip_on_launch = true
  tags = {
    Name = "cs423-devops-public-2"
  }
}

resource "aws_subnet" "private_1" {
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.devops_assignment_4.id
  map_public_ip_on_launch = true
  tags = {
    Name = "cs423-devops-private-1"
  }
}

resource "aws_subnet" "private_2" {
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.devops_assignment_4.id
  map_public_ip_on_launch = true
  tags = {
    Name = "cs423-devops-private-2"
  }
}


resource "aws_internet_gateway" "devops_assignment_4" {
  vpc_id = aws_vpc.devops_assignment_4.id
  tags = {
    Name = "devops-assignment-4-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.devops_assignment_4.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_assignment_4.id
  }
  tags = {
    Name = "devops-assignment-4-public-route-table"
  }
}

resource "aws_route_table_association" "public_1"{
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_1.id
}

resource "aws_route_table_association" "public_2"{
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_2.id
}

resource "aws_security_group" "devops_assignment_4_sg" {
  name        = "devops-assignment-4-sg"
  description = "Security group for devops assignment 4"
  vpc_id      = aws_vpc.devops_assignment_4.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-assignment-4-sg"
  }
}

resource "aws_key_pair" "cs423-assignment4-key" {
  key_name   = "cs423-assignment4-key"
  public_key = file("cs423-assignment4-key.pub")
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.devops_assignment_4_sg.id]
  subnet_id = aws_subnet.public_1.id
  key_name = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  user_data = <<-EOF
                  #!/bin/bash
                  apt-get update
                  apt-get install apache2 -y 
                  systemctl start apache2
                  systemctl enable apache2
                  EOF
  tags = {
    Name = "Web_Server"
  }
}

resource "aws_instance" "database_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.devops_assignment_4_sg.id]
  subnet_id = aws_subnet.private_1.id
  key_name = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  user_data = <<-EOF
                  #!/bin/bash
                  apt-get update
                  apt-get install wget software-properties-common ca-certificates apt-transport-https -y
                  apt install mariadb-server mariadb-client -y
                  systemctl start mariadb 
                  EOF
  tags = {
    Name = "DataBase"
  }
}
