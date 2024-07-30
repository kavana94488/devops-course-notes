provider "aws" {
  region = "ap-southeast-2"
}


variable "zones" {
        type = string
        default="ap-southeast-2a"
        description ="this is for variable"
}


variable "instance_type" {
        type = string
        default="t2.micro"
        description ="this is for variable"
}


resource "aws_instance" "web2" {
  ami           = "ami-086918d8178bfe266"
  instance_type = var.instance_type
  availability_zone = var.zones
  tags = {
    Name = "frontend"
  }

}


# to pass variable at run time

terraform apply --var=zones=ap-southeast-2b (or any value)

# to pass variable at run time from variable file , this is will be used for multiple variable

terraform apply --var=variablefile.tfvars
