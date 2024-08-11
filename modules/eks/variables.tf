variable "cluster_name" {
  type        = string
}

variable "profile" {
  description = "AWS profile name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "eks_vpc_id" {
  description = "VPC to deploy eks cluster"
  type        = string
}

variable "private_subnets" {
  description = "VPC private subnets"
  type        = list(any)
}

variable "rolearn" {
  description = "Add admin role to the aws-auth configmap"
  type = string
}