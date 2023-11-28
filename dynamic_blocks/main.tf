provider "aws" {
    region = "us-east-1"
}

variable "ingressrules" {
    type = list(number)
    default = [80,443]
}

variable "egressrules" {
    type = list(number)
    default = [80,443,25,3306,53,8080]
}

resource "aws_instance" "ec2" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.inboundTraffic.name, aws_security_group.outboundTraffic.name]
    tags = {
      Name = "terraform-example"
    }
}

resource "aws_security_group" "inboundTraffic" {
    name = "Allow HTTPS"
    description = "Allow inbound traffic"
    dynami "ingress" {
      iterator = port
      for_each = var.ingressrules
      content {
        from_port   = port.value
        to_port     = port.value
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
}

resource "aws_security_group" "outboundTraffic" {
    name = "Allow HTTPS"
    description = "Allow outbound traffic"
    dynamic "egress" {
      iterator = port
      for_each = var.egressrules
      content {
        from_port   = port.value
        to_port     = port.value
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
}