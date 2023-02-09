provider "aws" {
  region = var.region
}

#provider "aws" {
#  region = var.region
#  profile = "alphega"
#  assume_role {
#    role_arn = "arn:aws:iam::662737177474:role/OrganizationAccountAccessRole"
#  }
#  alias = "webhost"
#}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

#data "aws_caller_identity" "webhost" {
#  provider = aws.webhost
#}

#resource "random_string" "prefix" {
#  length  = 10
#  special = false
#  upper   = false
#}

locals {
  name         = var.name
#  cluster_name = "${var.name}-eks"
#  vpc_name     = "${var.name}-vpc"

  account_id = data.aws_caller_identity.current.account_id
#  webhost_account_id = data.aws_caller_identity.webhost.account_id

#  cert_manager_role = var.cert_manager_role

  oidc_issuer_url = split("//", module.eks.cluster_oidc_issuer_url)[1]
  eks_hash_id = split("/", module.eks.oidc_provider)[2]
#  eks_hash_id = ""
#  backup_bucket = format("alphega-%s-%s", local.cluster_name, random_string.prefix.result)

  tags = {
    Environment = var.environment
    Application = "zbi"
  }
}

