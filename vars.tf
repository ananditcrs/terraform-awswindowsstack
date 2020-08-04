variable "region" {
  description = "AWS Region"
  default  = "<region the one you wants this infra should be provisioned i.e. us-east-1"
}
variable "access_key" {
  description = "AWS API Access Key"
  default = "<your aws access key>"
}
variable "secret_key" {
  description = "AWS API Secret Key"
  default = "<your aws secret key>"
}
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.10.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.10.0.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "us-east-1a"
}
variable "public_key_path" {
  description = "Public key path"
  # default = "~/.ssh/id_rsa.pub"
  default = "C:\\Users\\bliss14\\Documents\\bliss_medbooks\\medbook.pub"
}
variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  # default = "ami-0cf31d971a3ca20d6"
  default = "ami-081afb283b98a8548"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}
variable "environment_tag" {
  description = "Environment tag"
  default = "Production"
}