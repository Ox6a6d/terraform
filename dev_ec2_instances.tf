provider "aws" {
  region     = "${var.region}"
}
variable "region" {
  default = "us-west-2"
}
resource "aws_instance" "dev_ec2_instances" {
  instance_type = "t2.micro"
  key_name = "jm430-aws-key"
}
resource "aws_instance" "dev_ec2_instance_2" {
  instance_type = "t2.micro"
  key_name = "jm430-aws-key"
}
