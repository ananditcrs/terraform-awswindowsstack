output "vpc_id" {
  value = aws_vpc.production-vpc.id
}
output "public_subnets" {
  value = [aws_subnet.public_A.id]
}
output "public_route_table_ids" {
  value = [aws_route_table.rtb_public.id]
}
output "public_instance_ip" {
  value = [aws_instance.prod_ec2instance[0].public_ip,aws_instance.prod_ec2instance[1].public_ip]
}