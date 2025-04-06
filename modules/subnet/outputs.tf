output "subnet_id" {
  value = aws_subnet.myapp-subnet-1.id
}

output "route_table_id" {
  value = aws_route_table.myapp-route-table.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.myapp-internet_gw.id
}