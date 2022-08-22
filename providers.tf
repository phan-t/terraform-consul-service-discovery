terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.35.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  /*default_tags {
    tags = {
      owner = var.owner
      TTL = var.ttl
    }
  }*/
}

#Provider configuration for primary dc1 kubernetes cluster and helm
data "aws_eks_cluster" "dc1" {
  name = module.infra-aws.eks_cluster_ids["dc1"]
}

provider "kubernetes" {
  alias = "dc1"
  host                   = data.aws_eks_cluster.dc1.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.dc1.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.dc1.name]
  }
}

provider "helm" {
  alias = "dc1"
  kubernetes {
    host                   = data.aws_eks_cluster.dc1.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.dc1.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.dc1.name]
    }
  }
}


#Provider configuration for secondary dc2 kubernetes cluster and helm
data "aws_eks_cluster" "dc2" {
  name = module.infra-aws.eks_cluster_ids["dc2"]
}

provider "kubernetes" {
  alias = "dc2"
  host                   = data.aws_eks_cluster.dc2.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.dc2.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.dc2.name]
  }
}

provider "helm" {
  alias = "dc2"
  kubernetes {
    host                   = data.aws_eks_cluster.dc2.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.dc2.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.dc2.name]
    }
  }
}