module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  create = true
  cluster_name    = local.name
  cluster_version = var.eks_cluster_version

  enable_irsa     = var.eks_enable_irsa

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  cloudwatch_log_group_retention_in_days = var.eks_cluster_log_retention_in_days
  cluster_enabled_log_types     = var.eks_cluster_enabled_log_types

  cluster_addons = {
    aws-ebs-csi-driver = {
      version = "v1.11.4-eksbuild.1"
      service_account = "zbi-ebs-csi-sa"
      service_account_role_arn = aws_iam_role.ebs-csi-role[0].arn
      namespace = "kube-system"
      resolve_conflicts = "OVERWRITE"
    }
  }
#  cluster_addons = {
#    coredns = {
#      resolve_conflicts = "OVERWRITE"
#    }
#    kube-proxy = {}
#    vpc-cni = {
#      resolve_conflicts = "OVERWRITE"
#      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
#    }
#  }

  cluster_tags = merge(local.tags)

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  manage_aws_auth_configmap = true

  # Extend Cluster security group rules
  cluster_security_group_additional_rules = {
    egress_noes_ephemeral_ports_tcp = {
      description = "To node 1025-65535"
      protocol = "tcp"
      from_port = 1025
      to_port = 65535
      type = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocol"
      protocol = "-1"
      from_port = 0
      to_port = 0
      type = "ingress"
      self = true
    }
    egress_all = {
      description = "Node all egress"
      protocol = "-1"
      from_port = 0
      to_port = 0
      type = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    instance_types = ["m5.xlarge"]
    iam_role_attach_cni_policy = true
  }

  eks_managed_node_groups = {
    nodes = {
      min_size = var.eks_node_group_default_min_capacity
      max_size = var.eks_node_group_default_max_capacity
      desired_size = var.eks_node_group_default_desired_capacity
      instance_types = var.eks_node_group_default_instance_types

      subnet_ids = module.vpc.private_subnets
#      vpc_security_group_ids = [aws_security_group.additional.id]

      create_iam_role = true
      iam_role_name = "eks-mng-nodes"
      iam_role_use_name_prefix = false
#      iam_role_description = "EKS managed node group for nodes"
      iam_role_tags = merge(local.tags, {Type: "Role"})
      iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]

      tags = merge(local.tags)
    }

  }
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = module.eks.eks_managed_node_groups
  policy_arn = aws_iam_policy.node_additional.arn
  role       = each.value.iam_role_name
}

resource "aws_iam_policy" "node_additional" {
  name = "${local.name}-additional"
  description = "Additional policy for managed nodes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["ec2:Describe*"]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = merge(local.tags)
}

#module "vpc_cni_irsa" {
#  source  = "terraform-aws-modules/service/aws//modules/service-role-for-service-accounts-eks"
#  version = "~> 4.12"
#
#  role_name_prefix = "VPC-CNI-IRSA"
#  attach_vpc_cni_policy = true
#  vpc_cni_enable_ipv6 = false
#
#  oidc_providers = {
#    main = {
#      provider_arn = module.eks.oidc_provider_arn
#      namespace_service_accounts = ["kube-system:aws-node"]
#    }
#  }
#
#  tags = merge(local.tags)
#}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
