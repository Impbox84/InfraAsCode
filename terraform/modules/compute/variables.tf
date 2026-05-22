variable "subnet_id" {
    description = "The subnet ID (VPC Subnet) where to deploy the instance"
    type = string
}

variable "vpc_id" {
    description = "The ID of the main VPC"
    type = string
}