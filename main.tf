provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source             = "./modules/subnet"
  subnet_cidr_block  = var.subnet_cidr_block
  avail_zone         = var.avail_zone
  env_prefix         = var.env_prefix
  vpc_id             = aws_vpc.myapp-vpc.id
}

module "myapp-server" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.myapp-vpc.id
  env_prefix = var.env_prefix
  image_name = var.image_name
  instance_type = var.instance_type
  subnet_id = module.myapp-subnet.subnet_id  # module.<module name>.<check output file of the modules>
  avail_zone = var.avail_zone

}
