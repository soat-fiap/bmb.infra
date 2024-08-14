variable "name" {
  description = "Load balancer controller name"
  type = string
  default = "techchallenge-internal"
}

################################################################################
# General Variables from root module
################################################################################

variable "region" {
  type    = string
}

variable "cluster_name" {
  type    = string
}

################################################################################
# Variables from other Modules
################################################################################

variable "vpc_id" {
  description = "VPC ID which Load balancers will be  deployed in"
  type = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN used for IRSA "
  type = string
}