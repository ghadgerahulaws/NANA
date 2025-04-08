provider "kubernetes" {
    load_config_file = "false"
    host = 
  config_path    = "~/.kube/config"
  config_context = "my-context"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}

data "aws_eks_clsuter" "myapp-cluster" {
    name = module.eks.cluster_id
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.35.0"

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.31"
  subnet_ids =  module.myapp_vpc.private_subnets
  vpc_id = module.myapp_vpc.vpc_id

  tags = {
    environment = "development"
    application = "myapp"
  }

eks_managed_node_groups = {
    example = {
        ami_type = "AL2023_x86_64_STANDARD"
        instance_types =  ["m5.xlarge"]
        min_size     = 2
        max_size     = 10
        desired_size = 2
    }
}

}