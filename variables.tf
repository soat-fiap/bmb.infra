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