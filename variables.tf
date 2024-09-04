variable "eks_vpc_name" {
  description = "VPC name"
  type        = string
  default     = "eks-fiap-vpc"
}

variable "profile" {
  description = "AWS profile name"
  type        = string
  default     = "default"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "quixada"
}

variable "nlb_name" {
  type    = string
  default = "bmb-apgw-eks"
}

variable "secret_key" {
  type      = string
  default   = "eI7lFBAo3/mga422TorDlNpcO/2blmerTbToa2do"
  sensitive = true
}