variable "Dedicated_WebServer_VPC_CIDRs" {
    description = "CIDR block for Dedicated Webservers VPC"
    default = "10.0.0.0/16"
}

variable "Dedicated_WebServer_PrivateSubnet_CIDRs" {
    description = "CIDR block for private subnets in Dedicated Webservers VPC"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "Dedicated_Webserver_PublicSubnet_CIDRs" {
    description = "CIDR block for public subnets in Dedicated Webservers VPC"
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "Dedicated_WebServer_AZs" {
    description = "AZs for public and private subnets in Dedicated webservers VPC"
    default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "ami_value" {
    description = "ami value to be used to launch webserver nginx in public subnet of Dedicated Webservers VPC"
    default = "ami-022ce6f32988af5fa"
}

variable "instance_type_value" {
    description = "instance type for ec2 instance"
    default = "t2.micro"
}