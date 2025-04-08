provider "aws" {
    region = "us-east-1"
  
}

variable "vpc_cidr_block" {}
variable "private_subnets_cidr_block" {}
variable "public_subnets_cidr_block" {}

data "aws_availability_zones" "azs" {
  
}

module "myapp_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnets_cidr_block
  public_subnets = var.public_subnets_cidr_block
  # azs = ["us-east-1a","us-east-1b","us-east-1c"]
  azs = data.aws_availability_zones.azs.name
  enable_nat_gateway = true #default one NAT gw per subnet
  single_nat_gateway = true #all private subnets will route their internet traffic through this single NAT gw
  enable_dns_hostnames = true 

  tags = {
    "kubernet.io/cluster/myapp-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernet.io/cluster/myapp-eks-cluster" = "shared"
    "kubernet.io/role/elb" = 1

  }

  private_subnet_tags = {
    "kubernet.io/cluster/myapp-eks-cluster" = "shared"
    "kubernet.io/role/internal-elb" = 1
  }

}