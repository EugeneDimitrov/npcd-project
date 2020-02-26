# vmcreate.tf
provider "aws" {
  region     = "eu-west-3"
}

resource "aws_instance" "example" {
  ami           = "ami-051ebe9615b416c15" # Ubuntu 16.04 LTS AMD64 in eu-west-3
  instance_type = "t2.micro"
  key_name        = "${aws_key_pair.jumpstation.key_name}"
  security_groups = ["${aws_security_group.allow_ssh.name}"]
}

resource "aws_key_pair" "jumpstation" {
  key_name   = "jumpstation"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

output "example_public_dns" {
  value = "${aws_instance.example.public_dns}"
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

