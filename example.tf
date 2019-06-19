provider "aws" {
  region     = "${var.region}"
}
variable "region" {
  default = "us-west-2"
}
variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-2" = "ami-0b4a4b368aa8bd6f0"
  }
}
resource "aws_instance" "example" {
  count = 2
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.instance.name}"]
  key_name = "jm430-aws-key"

#  provisioner "local-exec" {
#  command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
#  }
}
resource "aws_eip" "ip" {
  count = 2
  instance = "${element(aws_instance.example.*.id, count.index)}"
}
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["8.44.182.21/32","24.6.101.19/32"]
  }
  ingress {
    from_port = 8888
    to_port = 8888
    protocol = "tcp"
    cidr_blocks = ["8.44.182.21/32","24.6.101.19/32"]
  }
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["172.31.22.120/32","172.31.19.197/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
