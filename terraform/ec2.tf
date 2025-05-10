resource "aws_instance" "fintrack-app" {
  ami                         = "ami-0e35ddab05955cf57"
  subnet_id                   = aws_subnet.realops-public-subnet1.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.realops-sg1.id]
  associate_public_ip_address = true
  key_name                    = "connect"
  user_data                   = file("./scripts/user-data.sh")
  tags = {
    Name = "fintrack-app"
    env  = "dev"
  }
}