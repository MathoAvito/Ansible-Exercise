variable "vpc_prefix" {
  type = string
  default = "16"
}

variable "vpc_cidr" {
  type        = string
  description = ""
  default     = "10.0.0.0/16"

}

