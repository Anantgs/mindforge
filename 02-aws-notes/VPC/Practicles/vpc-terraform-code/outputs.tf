output "http1_url" {
  description = "Open this URL to see the http1 web server."
  value       = "http://${aws_instance.web["public_1"].public_ip}"
}

output "http2_url" {
  description = "Open this URL to see the http2 web server."
  value       = "http://${aws_instance.web["public_2"].public_ip}"
}

output "private_subnet_ids" {
  description = "The two private application subnet IDs."
  value       = { for name, subnet in aws_subnet.private : name => subnet.id }
}

output "database_subnet_ids" {
  description = "The two isolated database subnet IDs."
  value       = { for name, subnet in aws_subnet.database : name => subnet.id }
}

output "nat_gateway_public_ip" {
  description = "Elastic public IP used by the shared NAT Gateway."
  value       = aws_eip.nat.public_ip
}
