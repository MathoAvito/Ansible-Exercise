variable "ansible_hosts" {
  description = "The number of the ansible hosts"
  default     = 2
  type        = number
}

variable subnets {}

variable security_groups {}
