variable "name" {
  description = "Load balancer controller name"
  type        = string
  nullable = false
}

variable "enabled" {
  type    = bool
  default = true
}

variable "create" {
  type    = bool
  default = false
}
################################################################################
# General Variables from root module
################################################################################

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

################################################################################
# Variables from other Modules
################################################################################

variable "vpc_id" {
  description = "VPC ID which Load balancers will be  deployed in"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN used for IRSA "
  type        = string
}
