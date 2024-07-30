provider "aws" {
    region = "ap-southeast-2"
}

resource "aws_instance" "web" {
    ami="xxxxxxxxx "
    instance_type="t2.micro"
    tags = {
        Name=" xyz"
    }
}