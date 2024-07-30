provider "aws" {
    region = "ap-southeast-2"
}

resource "aws_instance" "web" {
    ami="xxxxxxxxx "
    instance_type="t2.micro"
    count=2
    tags = {
        Name=" xyz-${count.index+1}"
    }
}

#
xyz1 ,xyz2 will get created