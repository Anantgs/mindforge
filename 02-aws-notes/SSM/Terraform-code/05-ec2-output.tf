# output "bastion_instance_ids" {
#   description = "The IDs of the bastion host EC2 instances"  
#   value = [ for instance in aws_instance.myec2vm-bastion-vpc-1 : instance.id ]
# }

# output "bastion_instance_ips" {
#     description = "The public IPs of the bastion host EC2 instances"
#     value = [for ips in aws_instance.myec2vm-bastion-vpc-1 : ips.public_ip]
# }

# output "public_dns_names" {
#     description = "public dns names"
#     value = { for dns in aws_instance.myec2vm-bastion-vpc-1 : dns.public_ip => dns.public_dns }
# }

# output "ec2_raw_output" {
#     description = "Raw output of EC2 instances"
#     value = aws_instance.myec2vm-bastion-vpc-1
# }