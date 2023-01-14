output "subnets" {
  value = aws_subnet.main
}


output "security_groups" {
  value = aws_security_group.allow_ssh_http
}

output "vpc_id" {
  description = "VPC's id"
  value       = aws_vpc.main.id
}
