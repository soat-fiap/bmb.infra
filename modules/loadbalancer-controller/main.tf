# load balancer controller role
module "lb_role" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version     = "~> 5.44.0"

  role_name                              = "${var.name}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "service-account" {
  depends_on = [module.lb_role]

  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "alb-controller" {
  depends_on = [kubernetes_service_account.service-account]

  name         = "aws-load-balancer-controller"
  repository   = "https://aws.github.io/eks-charts"
  chart        = "aws-load-balancer-controller"
  version      = "~> 1.8.2"
  force_update = true
  namespace    = "kube-system"

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  # https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  #   set {
  #     name  = "image.repository"
  #     value = "602401143452.dkr.ecr.${var.region}.amazonaws.com/amazon/aws-load-balancer-controller"
  #   }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}

resource "kubernetes_service" "bmb-api-svc" {
  depends_on = [helm_release.alb-controller]
  metadata {
    name = "nlb-controller-svc"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-name" = "${var.name}"
    }
  }
  spec {
    port {
      port        = 80
      target_port = 8080
      node_port   = 30000
      protocol    = "TCP"
    }
    type = "LoadBalancer"
    selector = {
      app : "bmb-api"
    }
  }
}
