provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

resource "aws_ecr_repository" "repository" {
  name = "my-ecr-repository"
}


variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = [
    {
      name    = "kube-proxy"
      version = "v1.27.1-eksbuild.2"
    },
    {
      name    = "vpc-cni"
      version = "v1.12.6-eksbuild.1"
    # },
    # {
    #   name    = "coredns"
    #   version = "v1.10.1-eksbuild.1"
    }
  ]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.27"
  subnets         = ["subnet-814609de", "subnet-5d727653", "subnet-76337110"]
  vpc_id          = "vpc-a663fcdb"

  node_groups = {
    eks_nodes = {
      desired_capacity = 1
      max_capacity     = 10
      min_capacity     = 1

      instance_type = "t2.micro"
      key_name      = "my-key-name"

      additional_tags = {
        Environment = "test"
        Name        = "eks-worker-node"
      }
    }
  }
}


resource "aws_eks_addon" "addons" {
  for_each          = { for addon in var.addons : addon.name => addon }
  cluster_name      = module.eks.cluster_id
  addon_name        = each.value.name
  addon_version     = each.value.version
  resolve_conflicts = "OVERWRITE"
}


output "ecr_repository_url" {
  description = "The URL of the ECR Repository"
  value       = aws_ecr_repository.repository.repository_url
}

output "eks_cluster_id" {
  description = "The name of the EKS Cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS Cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "The security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "eks_cluster_iam_role_name" {
  description = "The IAM role name associated with EKS cluster"
  value       = module.eks.cluster_iam_role_name
}
