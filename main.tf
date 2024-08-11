terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "FiapPostech-SOAT"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "bmb-infra"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.62.0"
    }
  }

  required_version = ">= 1.2.0"
}

module "vpc" {
  source = "./modules/vpc"

  region  = var.region
  profile = var.profile
  name    = "${var.eks_vpc_name}-vpc"
}

module "eks" {
  source  = "./modules/eks"
  region  = var.region
  profile = var.profile

  cluster_name    = var.cluster_name
  eks_vpc_id      = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

module "loadbalancer-controller" {
  source            = "./modules/loadbalancer-controller"
  oidc_provider_arn = module.eks.oidc_provider_arn
  app_name          = "techchallenge-loadbalancer-controller"
  cluster_name      = module.eks.cluster_name
  region            = var.region
  vpc_id            = module.vpc.vpc_id
}
