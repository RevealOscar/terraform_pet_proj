provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    security_groups = [aws.inboundTraffic.name, aws_security_group.outboundTraffic.name]
      tags = {
        Name = "terraform-example"
      }
}

resource "aws_security_group" "inboundTraffic" {
    name = "Allow HTTPS"
    description = "Allow inbound traffic"
    ingress {
      from_port = 443
      to_port   = 443
      protocol  = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outboundTraffic" {
    name = "Allow HTTPS"
    description = "Allow outbound traffic"
    egress {
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
}