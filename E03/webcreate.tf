# webcreate.tf
provider "aws" {
  region     = "eu-west-3"
}

resource "aws_instance" "server" {
  ami           = "ami-051ebe9615b416c15" # Ubuntu 16.04 LTS AMD64 in eu-west-3
  instance_type = "t2.micro"
  key_name      = aws_key_pair.jumpstation.key_name   # b4 was "${aws_key_pair.jumpstation.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_ssh.name}",
    "${aws_security_group.allow_http.name}",
    "${aws_security_group.allow_outbound.name}",
  ]
}

resource "aws_key_pair" "jumpstation" {
  key_name   = "jumpstation"
  public_key = file("~/.ssh/id_rsa.pub")   # b4 was "${file("~/.ssh/id_rsa.pub")}"
}

output "server_public_dns" {
  value = "${aws_instance.server.public_dns}"
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh_group"
  description = "Allow traffic on port 22 (SSH)"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "allow_http" {
  name = "allow_http_group"
  description = "Allow traffic on port 80 (HTTP)"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "allow_outbound" {
  name = "allow_outbound_group"
  description = "Allow traffic to leave the AWS instance"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_s3_bucket" "srvbucket" {
  bucket = "srvbucket"
  acl    = "public-read"
  policy = file("policy.json")  
}

resource "aws_s3_bucket_object" "index_file" {
  bucket = aws_s3_bucket.srvbucket.id 
  content_disposition = ""
  content_type = "text/html"
  key    = "index.html"
  source = "index2.html"
  etag = filemd5("index2.html")  
}

resource "aws_s3_bucket_object" "icon_file" {
  bucket = aws_s3_bucket.srvbucket.id   
  content_disposition = ""
  key    = "icon.jpg"
  source = "icon.jpg"
  etag = filemd5("icon.jpg")
}

resource null_resource "ansible_web" {
  depends_on = [
    aws_instance.server  # b4 was "aws_instance.server"
  ]

  provisioner "local-exec" {
    command = "sleep 10; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -e 'ansible_python_interpreter=/usr/bin/python3' -u ubuntu --private-key ~/.ssh/id_rsa -i ${aws_instance.server.public_ip}, ansible/main.yml"
  }
}


