
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "vpc_gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1a"
  map_public_ip_on_launch = "true"

}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = "true"
}

resource "aws_redshift_subnet_group" "subnet_group" {
  name       = var.obj_prefix
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}