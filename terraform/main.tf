terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.28.0"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
  access_key = "ASIAZQNB3KHGF4B4BBMH"
  secret_key = "jHvpnsLkejZWUQ5pbYJPe2yB7k6Tp6K2+GCH55UI"
}

resource "aws_security_group" "allow_ssh_from_anywhere" {
  name        = "allow ssh"
  description = "allow incoming connections from ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "test"
    from_port   = 5342
    to_port     = 5342
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "allow_port_80_from_anywhere" {
  name        = "allow_port_80_from_anywhere"
  description = "Allow port 80 inbound traffic from anywhere"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_port_80_from_anywhere"
  }
}

data "aws_ami" "amazon2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon2.id
  instance_type               = "t3.nano"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_from_anywhere.id, aws_security_group.allow_port_80_from_anywhere.id]

  user_data = <<-EOF
    #!/bin/bash
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World</h1>" > /var/www/html/index.html
  EOF


}
