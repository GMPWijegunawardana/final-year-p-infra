data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]

  user_data = file("user-data/jenkins.sh")

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_instance" "minikube" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]

  user_data = file("user-data/minikube.sh")

  tags = {
    Name = "Minikube-Server"
  }
}
