/*data "aws_instance" "ansible_host1" {
  instance_id = aws_instance.ansible_host[0].id
} */

/* data "aws_instance" "ansible_host2" {
  instance_id = aws_instance.ansible_host[1].id
} */


variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "region" {
  description = "The region to build the infrastructure in"
  default     = "eu-west-3"
  type        = string
}


variable ansible_hosts {}

/* variable "allowed_cidrs" {
  type = list(string)
  description = "List of CIDR blocks that are allowed to access resources in the VPC. The list contains the two ansible hosts and my own IP address"
  default = [data.aws_instance.ansible_host[0].public_ip, data.aws_instance.ansible_host[1].public_ip, "${var.my_ip}"]
} */