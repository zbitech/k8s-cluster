
#resource "aws_iam_role_policy" "zbi-dns-manager-policy" {
#  policy = file("dns-manager-")
#  role   = ""
#}
#
#resource "aws_iam_role_policy_attachment" "zbi-dns-manager" {
#  policy_arn = ""
#  role       = ""
#}

data "aws_iam_policy_document" "cert-manager-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${local.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${local.eks_hash_id}"]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:cert-manager:cert-manager"]
      variable = "oidc.eks.${var.region}.amazonaws.com/id/${local.eks_hash_id}:sub"
    }
  }
}

data "aws_iam_policy_document" "cert-manager-permission-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    resources = [var.dns_manager_role_arn]
  }
}

resource "aws_iam_role" "cert-manager" {
  count = var.enable_cert_manager ? 1 : 0
  name = var.cert_manager_role_name
  description = "ZBI certificate manager role"
  assume_role_policy = data.aws_iam_policy_document.cert-manager-assume-role-policy.json

  inline_policy {
    name = "dns-manager-policy"
    policy = data.aws_iam_policy_document.cert-manager-permission-policy.json
  }

  depends_on = [module.eks]
}



data "aws_iam_policy_document" "ebs-csi-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${local.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${local.eks_hash_id}"]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:${var.csi_namespace}:${var.ebs_csi_serviceaccount}"]
      variable = "oidc.eks.${var.region}.amazonaws.com/id/${local.eks_hash_id}:sub"
    }
  }
}

resource "aws_iam_role" "ebs-csi-role" {
  count = var.enable_ebs_csi ? 1 : 0
  name = var.ebs_csi_role_name
  description = "ZBI csi driver role for EBS storage"
  assume_role_policy = data.aws_iam_policy_document.ebs-csi-assume-role-policy.json

  inline_policy {
    name = "ebs-policy"
    policy = file("policy/ebs-csi-permission-policy.json")
  }
}

data "aws_iam_policy_document" "efs-csi-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${local.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${local.eks_hash_id}"]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:${var.csi_namespace}:${var.efs_csi_serviceaccount}"]
      variable = "oidc.eks.${var.region}.amazonaws.com/id/${local.eks_hash_id}:sub"
    }
  }
}

resource "aws_iam_role" "efs-csi-role" {
  count = var.enable_efs_csi ? 1 : 0
  name = var.efs_csi_role_name
  description = "ZBI csi driver role for EFS storage"
  assume_role_policy = data.aws_iam_policy_document.efs-csi-assume-role-policy.json

  inline_policy {
    name = "efs-policy"
    policy = file("policy/efs-csi-permission-policy.json")
  }
}