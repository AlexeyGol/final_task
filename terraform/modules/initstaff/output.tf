output "subnet" {
    value = aws_subnet.myapp-subnet-1
}

output "route_table" {
    value = "aws_route_table.myapp-route-table"
}

output "internet_gateway" {
    value = aws_internet_gateway.myapp-igw
}
