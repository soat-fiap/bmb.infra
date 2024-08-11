terraform {
  backend "remote" {
    organization = "FiapPostech-SOAT"
    workspaces {
      name = "bmb-infra"
    }
  }
}

# provider "aws" {
#   profile = var.profile
#   region  = "us-east-1"
#   alias   = "us-east-1"
# }

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
