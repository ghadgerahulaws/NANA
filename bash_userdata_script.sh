#!/bin/bash
                sudo yum update -y && yum install -y docker
                sudo systemctl start docker
                sudo useradd -aG docker ec2-user
                docker run -p 8080:80 nginx
