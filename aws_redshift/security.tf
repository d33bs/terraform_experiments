resource "aws_default_security_group" "group" {
  vpc_id     = aws_vpc.vpc.id
  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}