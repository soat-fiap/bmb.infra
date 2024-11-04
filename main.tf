module "vpc" {
  source = "./modules/vpc"

  region  = var.region
  profile = var.profile
  name    = var.eks_vpc_name
}

module "eks" {
  source  = "./modules/eks"
  region  = var.region
  profile = var.profile

  cluster_name    = var.cluster_name
  eks_vpc_id      = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

# module "loadbalancer-controller" {
#   depends_on        = [module.eks]
#   source            = "./modules/loadbalancer-controller"
#   oidc_provider_arn = module.eks.oidc_provider_arn
#   name              = var.nlb_name
#   cluster_name      = module.eks.cluster_name
#   region            = var.region
#   vpc_id            = module.vpc.vpc_id
# }

#################################
# SEQ
#################################

resource "kubernetes_namespace" "fiap_log" {
  metadata {
    name = "fiap-log"
  }
}

resource "kubernetes_service" "svc_seq" {
  metadata {
    name      = "api-internal"
    namespace = kubernetes_namespace.fiap_log.metadata.0.name
    labels = {
      "terraform" = true
    }
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"   = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internal"
    }
  }
  spec {
    type = "LoadBalancer"
    port {
      port      = 80
      node_port = 30008
    }
    selector = {
      app = "seq"
    }
  }
}

resource "kubernetes_deployment" "deployment_seq" {
  metadata {
    name      = "deployment-seq"
    namespace = kubernetes_namespace.fiap_log.metadata.0.name
    labels = {
      app         = "seq"
      "terraform" = true
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "seq"
      }
    }
    template {
      metadata {
        name = "pod-seq"
        labels = {
          app         = "seq"
          "terraform" = true
        }
      }
      spec {
        automount_service_account_token = false
        container {
          name  = "seq-container"
          image = "datalust/seq:latest"
          port {
            container_port = 80
          }
          image_pull_policy = "IfNotPresent"
          env {
            name  = "ACCEPT_EULA"
            value = "Y"
          }
          resources {
            requests = {
              cpu    = "50m"
              memory = "120Mi"
            }
            limits = {
              cpu    = "100m"
              memory = "220Mi"
            }
          }
        }
        volume {
          name = "dashboards-volume"
          host_path {
            path = "/home/docker/seq"
          }
        }
      }
    }
  }
}
