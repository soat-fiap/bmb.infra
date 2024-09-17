terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.62.0"
    }
  }
  required_version = "~>1.9.4"
}

provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "us-east-1"
  # access_key = var.access_key
  # secret_key = var.secret_key

  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#   }
# }

# provider "helm" {
#   # https://github.com/hashicorp/terraform-provider-helm/issues/630#issuecomment-996682323
#   repository_config_path = "${path.module}/.helm/repositories.yaml"
#   repository_cache       = "${path.module}/.helm"
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#       command     = "aws"
#     }
#   }
# }
