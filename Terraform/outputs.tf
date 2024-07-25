output "Public_subnet_ids" {
    value = aws_subnet.Dedicated_Webserver_PublicSubnet[*].id
}

output "EC2_instance_publicip" {
    value = aws_instance.Nginx_WebServer.public_ip
}