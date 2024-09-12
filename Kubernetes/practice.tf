provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags={
        Name="myvpc"
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
    tags={
        Name="igw"
    }
}

resource "aws_subnet" "public_subnet" {
      vpc_id=aws_vpc.myvpc.id
      availabilty_zone= "ap-southeast-1a"
      cidr_block="10.0.1.0/24"
      tags={
        Name="public_subnet"
      }
}

resource "aws_eip" "eip" {
    vpc = true
    tags={
        Name="eip"
    }
}

resource "aws_subnet" "private_subnet"{
    vpc_id=aws_vpc.myvpc.id
    availabilty_zone = "ap-southeast-1a"
    cidr_block ="10.0.2.0/24"
    tags={
        Name="private_subnet"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eip.id
    subnet_id =aws_subnet.public_subnet.id
    depends_on = [aws_internet_gateway.igw.id]
    tags={
        Name="nat_gateway"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.myvpc.id
    route={
        cidr_block = "0.0.0.0/0"
        gateway_id = aws.internet_gateway.igw.id 
    }
    tags={
        Name="public_rt"
    }
}

resource "aws_route_table_association" "public_rt_association" {
subnet_id = aws_vpc.myvpc.id
route_table_id=aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
    vpc_id =aws_vpc.myvpc.id
    route={
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags={
        Name="private_rt"
    }
}

resource "aws_route_table_association" "private_rt_association" {
    subnet_id = aws_subnet.private_subnet_id
    route_table_id=aws_route_table.private_rt.id
}

resource "aws_security_group" "allow_ssh" {
    vpc_id = aws_vpc.myvpc.id
    ingress ={
        from_port =22
        to_port=22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0]
    }

    egress = {
        from_port=22
        to_port=22
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    tags={
        Name="sg"
    }
}

resource "aws_instance" "myinstane" {
    ami=""
    tags={
        name="myinstane"
    }
    subnet_id=aws_subnet.public_subnet.id
    instance_type="t2.micro"
}

output "vpc_id"{
    value = aws_vpc.myvpc.id
}

output "public_subnet_id" {
    value = aws_subnet.public_subnet.id
}

output "public_ip" {
    value=aws_instance.myinstance.public_ip
}

--------------------------------------

pipeline{
    agent any{
        environmet{
            repo_url="https://xyz.git.com"
            image_name="jenkins-docker"
        }
        stages{
            stage('cloining from git"){
                steps{
                    git branch:'main' url:"${env.repo_url}"

                }
            }
            stage('building image'){
                
                steps{
                 script{
                    docker.build("${env.image_name}")
                }

                }
            }

            stage('running the image'){
                steps{
                    script{
                        docker.image("${env.image_name}").run('-d -p 8080:8080')
                    }
                }
            }

            stage('pushing the image'){
                steps{
                 script{
                    docker.image("${env.image_name}").push('latest')
                 }
                }
            }
        }
    }
}

---------------------------------

provider "aws" {
    region="ap-southeast-2"
}

resource "aws_iam_user" "devops_user" {
    name=devops_user
}

resource "aws_iam_user_policy" "devops_user.policy" {
    policy = <<EOF 
}