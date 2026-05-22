variable "env_name" {
    description = "The name of the environnement (prod/preprod/dev) to specifiy the name of the VPC"
    type = string
}

variable "vpc_cidr" {
    description = "The block of IP address to allocate to the VPC"
    type = string
}

variable "private_subnet_cidr" {
    description = "The block of IP address from the VPC to allocate to the private subnet"
    type = string
}

variable "public_subnet_cidr" {
    description = "The block of IP address from the VPC to allocate to the public subnet"
    type = string
}