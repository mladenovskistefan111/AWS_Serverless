# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnets" {
  value = {
    for key, subnet in aws_subnet.private_subnets : key => subnet.id
  }
}