# Let's initialize availability zone data from AWS
data "aws_availability_zones" "available" {
	# we'll keep it w/o implementation as this would be filled by terraform aws api
}

# Configure the AWS Provider
provider "aws" {
	region = var.region
	access_key = var.access_key
	secret_key = var.secret_key
}

# Create a VPC
resource "aws_vpc" "production-vpc" {
	cidr_block = var.cidr_vpc
	instance_tenancy = "default"
	enable_dns_hostnames = true
	enable_dns_support = true

	tags = {
		"Environment" = var.environment_tag
	}
	
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
	vpc_id = aws_vpc.production-vpc.id
	cidr_block = var.cidr_subnet
	map_public_ip_on_launch = true
	availability_zone = var.availability_zone
	tags = {
		"Environment" = var.environment_tag
	}
}

# Create an internet gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    "Environment" = var.environment_tag
  }
}

# Create route table
resource "aws_route_table" "rtb_public" {
	vpc_id = aws_vpc.production-vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}
	tags = {
		"Environment" = var.environment_tag
	}
	
}

# Let's  do route association to subnet
resource "aws_route_table_association" "rta_subnet_public" {
	subnet_id = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.rtb_public.id
	
}

# Create a security group
resource "aws_security_group" "sgrp_webapp" {
	name = "sgrp_webapp"
	vpc_id = aws_vpc.production-vpc.id

	# Inbound SSH access from the VPC
	ingress {
		description = "RDP Access"
		from_port   = 3389
		to_port     = 3389
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Inbound Secure Web access from the VPC
	ingress {
		description = "Secure Web Access"
		from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Inbound Web access from the VPC
	ingress {
		description = "Web Access"
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Outbound Web Access to anywhere
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	tags = {
		"Environment" = var.environment_tag
	}
}
# Do key pairing to instance
resource "aws_key_pair" "ec2key" {
	key_name = "Medbook"
	public_key = file(var.public_key_path)
}

# Create a instance
resource "aws_instance" "prod_ec2instance" {
	ami = var.instance_ami
	instance_type = var.instance_type
	subnet_id = aws_subnet.public_subnet.id
  	vpc_security_group_ids = [aws_security_group.sgrp_webapp.id]
	key_name = aws_key_pair.ec2key.key_name
	count = 2

	tags = {
	 "Environment" = var.environment_tag 
	}
}