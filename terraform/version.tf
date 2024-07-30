
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50"
    }
  }
}


provider "aws" {
  region = "ap-southeast-2"
}



resource "aws_instance" "web2" {
  ami           = "ami-086918d8178bfe266"
  instance_type = "t2.micro"
  count         = 2
  tags = {
    Name = "frontend"
  }

}
