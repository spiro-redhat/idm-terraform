
variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpeCE64b3044fWE74BVCS2+N788xaD4B0GkJFN7p4BIUYjWITtLuCaFqhW3Oiqm1hO8lorazT/3F+eEunHOnm4gRqRdrN4UqBtD82+JyPQ40MkQkOKDoPMIvqtP1xZpSEqeOMDOKWuEEfxmVfq40XbMEgJFZ1YRV1Xc6nj7dioNlOxEKq4UDbGU9q/qyuaLEjg3+nOlYNgg9aZaL09zqY4mAMgaeQ9ENoWifwphptPqNcPi+wPZJGMsWCImlj+hC3WT+0wMJNYLl8oHma+d3ATJrine01DGnJpaJOUzY/GDcJZ3C6bT7AyBfB9o0JUintvwu/FRILN84rHcEBtfyfp"
}

variable "vpc_name" {
  type    = string
  default = "my_vpc"
}


variable "rhel9_ami" {
  type  = string 
  default = "ami-08e592fbb0f535224"
}

variable "rhel8_ami" {
  type  = string 
  default = "ami-07057a188b87059cf"
}





variable subnets {
    type = list(string)
    description = "List of all the subnets"
}