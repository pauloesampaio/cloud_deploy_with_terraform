terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile                 = "default"
  region                  = "sa-east-1"
  shared_credentials_file = var.aws_credentials
}

resource "aws_instance" "example" {
  key_name        = "ec2_sa"
  ami             = "ami-08caf314e5abfbef4"
  instance_type   = "t2.micro"
  security_groups = ["default"]
  tags = {
    Name = "terraform-instance"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.aws_keys)
  }

  provisioner "remote-exec" {
    inline = ["echo 'Up and running'", ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${self.public_ip}, --private-key=${var.aws_keys} -u ubuntu ./ansible/playbook.yml"
  }
}
