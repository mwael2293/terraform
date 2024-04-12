variable "instance_count" {
  type    = string
  default = "1"
}
variable "cidr" {
  type    = string
  default = "192.168.1.0/24"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type    = string
  default = "ami-023adaba598e661ac"
}


variable "allowed_ports" {
  description = "List of ports to allow"
  type        = list(number)
  default     = [80, 5001, 5432]
}