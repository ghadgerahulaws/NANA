provider "aws" {
    region = "us-east-1"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "instance_type" {}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
      Name: "${var.env_prefix}-vpc"
    }
  
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone

    tags = {
      Name: "${var.env_prefix}-subnet-1"
    }
  
}

resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id

    route {
        cidr_block = "0.0.0.0/16"
        gateway_id = aws_internet_gateway.myapp-internet_gw.id
    }
  tags = {
      Name: "${var.env_prefix}-rt"
    }

}

resource "aws_internet_gateway" "myapp-internet_gw" {
    vpc_id = aws_vpc.myapp-vpc.id

    tags = {
      Name: "${var.env_prefix}-ig"
    }
  
}

resource "aws_route_table_association" "a-rtb-association" {
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
  
}

#use default route table
/*resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  route = {
    cidr_block = "0.0.0.0/16"
    gateway_id = aws_internet_gateway.id6
  }

  tags = {
      Name: "${var.env_prefix}-vpc"
    }

}*/

resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags = {
      Name: "${var.env_prefix}-sg"
    }
  
}

data "aws_ami" "latest-amazon-ami" {
     most_recent = true
     owners = ["amazon"]
     filter {
       name = "name"
       values = ["amzn2-ami-hvm-*-x86_64-gp2"]
      
     }

     filter {
       name = "virtualization-type"
       values = ["hvm"]
     }

}

output "aws_ami" {
  value = data.aws_ami.latest-amazon-ami
  
}
resource "aws_key_pair" "myapp-key" {
  key_name = "myapp-key"
  public_key = file("terra.pub")
  
}
resource "aws_instance" "myapp-ec2" {

    ami = data.aws_ami.latest-amazon-ami.id 
    instance_type = var.instance_type
    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.myapp-key.key_name


      #for small data we can write this way
    /*user_data = <<EOF
                #!/bin/bash
                sudo yum update -y && yum install -y docker
                sudo systemctl start docker
                sudo useradd -aG docker ec2-user
                docker run -p 8080:80 nginx

                EOF
                */
      user_data = file("bash_userdata_script.sh")

    tags = {
      Name: "${var.env_prefix}-ec2"
    }
}