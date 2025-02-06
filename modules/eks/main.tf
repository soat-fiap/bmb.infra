module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.23.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  create_kms_key              = false
  create_cloudwatch_log_group = true
  cluster_enabled_log_types = [ "api", "audit", "authenticator", "controllerManager", "scheduler" ]
  cloudwatch_log_group_retention_in_days = 3
  cluster_encryption_config   = {}

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    amazon-cloudwatch-observability = {
      most_recent = true
    }
  }

  vpc_id                   = var.eks_vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]  
      iam_role_additional_policies = {
        "AmazonSQSFullAccess" = "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
        "AmazonSNSFullAccess" = "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
        "AmazonS3FullAccess" = "arn:aws:iam::aws:policy/AmazonS3FullAccess",
        "CloudWatchAgentServerPolicy" = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
      }
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true

  tags = {
    Terraform = "true"
  }
}

resource "helm_release" "metric_server" {
  depends_on = [ module.eks ]
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
}
