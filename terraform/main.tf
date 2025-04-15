provider "aws" {
  region     = "eu-north-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_security_group" "lab_sg" {
  name        = "lab6-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = null # Якщо ти не створюєш VPC вручну, можна пропустити або залишити null

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "lab_instance" {
  ami                    = "ami-0989fb15ce71ba39e" # Ubuntu 22.04, Stockholm
  instance_type          = "t3.micro"
  key_name               = "lab45"
  security_groups        = [aws_security_group.lab_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io
              systemctl start docker
              docker run -d -p 80:80 maximkhokhol/lab6
              EOF

  tags = {
    Name = "lab6-instance"
  }
}
