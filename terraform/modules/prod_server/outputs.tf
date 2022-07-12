output "prod_ip" {
    value = aws_instance.prod-server.public_ip
}