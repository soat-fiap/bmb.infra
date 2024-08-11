# terraform {
#   # backend "remote" {
#   #   organization = "PostechFiap"
#   #   workspaces {
#   #     name = "Example-WOrkspace"
#   #   }
#   # }
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }

#   required_version = ">= 1.2.0"
# }

# provider "aws" {
#   region = "us-east-1"
#   default_tags {
#     tags = {
#       Environment = "Test"
#       App         = "techchallenge"
#     }
#   }
# }

# resource "aws_vpc" "main_vpc" {
#   cidr_block           = var.vpc_cidr_block
#   instance_tenancy     = "default"
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = var.vpc_name
#   }
# }

# resource "aws_internet_gateway" "main_igw" {
#   vpc_id = aws_vpc.main_vpc.id

#   tags = {
#     Name = "techchallenge_main_igw"
#   }
# }

# # resource "aws_internet_gateway_attachment" "main_igw_attachment" {
# #   vpc_id              = aws_vpc.main_vpc.id
# #   internet_gateway_id = aws_internet_gateway.main_igw.id
# # }

# resource "aws_subnet" "public_subnet" {
#   vpc_id            = aws_vpc.main_vpc.id
#   cidr_block        = var.public_subnet_cidr_block
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "techchallenge_public_subnet"
#   }
# }

# resource "aws_route_table" "main_rt" {
#   vpc_id = aws_vpc.main_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main_igw.id
#   }

#   tags = {
#     Name = "techchallenge_main_rt"
#   }
# }

# # resource "aws_route" "main_routetointernet" {
# #   route_table_id         = aws_route_table.main_rt.id
# #   destination_cidr_block = "0.0.0.0/0"
# #   gateway_id             = aws_internet_gateway.main_igw.id
# # }

# resource "aws_route_table_association" "public_subnet_route_association" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.main_rt.id
# }
