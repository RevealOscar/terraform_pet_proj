provider "aws" {
    region = "us-east-1"
}


// Database


resource "aws_instance" "database" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    tags = {
        Name = "database"
    }
}

output "database_ip" {
    value = aws_instance.database.private_ip
}


// web server


resource "aws_instance" "web_server" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.web_server_security_group.name]
    user_data = file("script.sh")
    tags = {
        Name = "web_server"
    }
}

resource "aws_eip" "web_ip" {
  instance = aws_instance.web_server.id
  vpc = true
  tags = {
    Name = "Web Server IP
  }
}

variable "webserver_ingress_rules"{
  type = list(number)
  default = [80, 443]
}

variable "webserver_egress_rules" {
  type = list(number)
  default = [80, 443, 3306]
}

resource "aws_security_group" "web_server_security_group" {
  name = "web_server_security_group"
  description = "Allow traffic"
  dynamic "ingress" {
    iterator = port
    for_each = var.webserver_ingress_rules
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.webserver_egress_rules
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "web_server_ip" {
    value = aws_eip.web_server.public_ip
}