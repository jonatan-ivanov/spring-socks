terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "vmw-jivanov-tf-state"
    key    = "tf-state/us-west-2"
    region = "us-west-2"
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


resource "aws_instance" "s1-keynote-obs-demo" {
  # ami           = data.aws_ami.ubuntu.id # latest AMI
  ami           = "ami-0a1b477074e2f1708"
  instance_type = "t2.micro"
  key_name      = "s1-keynote-obs-demo"

  tags = {
    Name = "s1-keynote-obs-demo"
  }
}
