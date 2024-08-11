module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.12.1"

  name = var.name

  # providers = {
  #   aws = aws.us-east-1
  # }

  azs = ["us-east-1f", "us-east-1c"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24","10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Terraform = "true"
  }
}