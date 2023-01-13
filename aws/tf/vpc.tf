module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                 = local.name
  cidr                 = var.vpc_cidr_block
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.vpc_private_subnet_cidr
  public_subnets       = var.vpc_public_subnet_cidr
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames

  enable_flow_log = true
  create_flow_log_cloudwatch_iam_role = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  }

  tags = merge(
    local.tags
  )

}

#resource "aws_security_group" "additional" {
#  name_prefix = "${local.name}-additional"
#  vpc_id = module.vpc.vpc_id
#
#  ingress {
#    from_port = 22
#    protocol  = "tcp"
#    to_port   = 22
#    cidr_blocks = var.vpc_sg_ingress_cidr
#  }
#}

