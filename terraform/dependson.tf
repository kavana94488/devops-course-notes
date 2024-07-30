provider "aws" {
  region = "ap-southeast-2"
}



resource "aws_instance" "web2" {
  ami           = "ami-086918d8178bfe266"
  instance_type = "t2.micro"
  depends_on    = [aws_instance.web1]
  tags = {
    Name = "frontend"
  }

}

resource "aws_instance" "web1" {
  ami           = "ami-086918d8178bfe266"
  instance_type = "t2.micro"
  tags = {
    Name = "backend"
  }
  }

  # first backend will get created
  # first frontend will get destroyed
