resource "aws_vpc" "Dedicated_WebServer_VPC" {
    cidr_block = var.Dedicated_WebServer_VPC_CIDRs
    tags = {
      Name = "Dedicated VPC for webservers"
    }
}

resource "aws_subnet" "Dedicated_WebServer_PrivateSubnet" {
    count = length(var.Dedicated_WebServer_PrivateSubnet_CIDRs)
    vpc_id = aws_vpc.Dedicated_WebServer_VPC.id
    cidr_block = element(var.Dedicated_WebServer_PrivateSubnet_CIDRs, count.index)
    availability_zone = element(var.Dedicated_WebServer_AZs, count.index)
    tags = {
        Name = "Dedicated_WebServer Private ${count.index + 1}"
    }
}

resource "aws_subnet" "Dedicated_Webserver_PublicSubnet" {
    count = length(var.Dedicated_Webserver_PublicSubnet_CIDRs)
    vpc_id = aws_vpc.Dedicated_WebServer_VPC.id
    cidr_block = element(var.Dedicated_Webserver_PublicSubnet_CIDRs, count.index)
    availability_zone = element(var.Dedicated_WebServer_AZs, count.index)
    tags = {
        Name = "Dedicated_WebServer Public ${count.index + 1}"
    }
}

resource "aws_internet_gateway" "Dedicated_WebServer_IG" {
    vpc_id = aws_vpc.Dedicated_WebServer_VPC.id
    tags = {
        Name = "Dedicated_WebServer IG"
    }
}

resource "aws_route_table" "Dedicated_WebServer_RT" {
    vpc_id = aws_vpc.Dedicated_WebServer_VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Dedicated_WebServer_IG.id
    }
}

resource "aws_route_table_association" "Dedicated_WebServer_RT_Association" {
    count = length(var.Dedicated_Webserver_PublicSubnet_CIDRs)
    subnet_id = element(aws_subnet.Dedicated_Webserver_PublicSubnet[*].id, count.index)
    route_table_id = aws_route_table.Dedicated_WebServer_RT.id
}

resource "aws_security_group" "Dedicated_WebServer_PublicSG" {
    name = "SG for HTTP and SSH"
    vpc_id = aws_vpc.Dedicated_WebServer_VPC.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "Nginx_WebServer" {
    ami = var.ami_value
    instance_type = var.instance_type_value
    key_name = "March7th"
    subnet_id = aws_subnet.Dedicated_Webserver_PublicSubnet[0].id
    vpc_security_group_ids = [aws_security_group.Dedicated_WebServer_PublicSG.id]
    user_data = "script.sh"
    associate_public_ip_address = true
    tags = {
      Name = "Nginx Webserver 1"
    }
}