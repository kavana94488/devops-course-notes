
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

data "aws_ami" "myami" {
    most_recent=true
    owners=["self"]
    filter={
        name="name
         values=["myami"]    
}
}

output "public_ips" {
    value="aws_instance.web1.public.ip"
}

output "private_ips" {
    value="aws_instance.web1.private.ip"
}


locals {
    some_tag={
        Name=""
        owner=""
        ...etc
    }
}


resource "aws_instance" "rootvolume" {
  instance_type = "t2.micro"
  ami           = "ami-086918d8178bfe266"
  tags = {
    Name = "rootvolume"
  }

  root_block_device {
    volume_size          = 10
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
    tags = {
      Name = "root_volume"
    }
  }
}

--------------------------------------

module "frontend" {
  source = "./module/ec2"
}

module "backend" {
  source        = "./module/ec2"
  instance_type = "t2.medium"
}

module "test" {
  source         = "./module/ec2"
  instance_count = 2
}

------------------------------------

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "frontend" {
  ami               = "ami-086918d8178bfe266"
  instance_type     = "t2.micro"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "frontend"
  }
}

resource "aws_ebs_volume" "myvolume" {
  availability_zone = "ap-southeast-2a"
  size              = 10
  tags = {
    Name = "myvolume"
  }
}

resource "aws_volume_attachment" "attachment" {
  device_name = "/dev/sda"
  instance_id = aws_instance.frontend.id
  volume_id   = aws_ebs_volume.myvolume.id
}

