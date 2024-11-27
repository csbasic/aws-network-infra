variable "AWS_REGION" {
  type    = string
  default = "us-east-2"
}


variable "vpc_cidr" {
  description = "VPC CIDR Block"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDR"
}
