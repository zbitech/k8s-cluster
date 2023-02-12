variable "name" {
  description = "Name of the project"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment"
  type = string
  default = "sandbox"
}

#**********************
# VPC settings
#***********************

variable "vpc_cidr_block" {
  description = "The CIDR Block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "enable_nat_gateway" {
  description = "Indicator to enable NAT gateway in the VPC"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Indicator to deploy single NAT gateway in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Indicator to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_sg_ingress_cidr" {
  description = "VPC Security Group Ingress CIDR block"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}


#*********************
# Roles
#*********************
variable "dns_manager_role_arn" {
  description = ""
  type        = string
  default     = "arn:aws:iam::662737177474:role/dns-manager"
}

variable "dns_manager_role_name" {
  description = ""
  type        = string
  default     = "dns-manager"
}

variable "enable_cert_manager" {
  description = "Enable certificate manager"
  type = bool
  default = true
}

# variable "extern_dns_role_name" {
#   description = "External DNS role name"
#   type        = string
# }

variable "cert_manager_role_name" {
  description = "Certificate manager role name"
  type        = string
  default     = "zbi-cert-manager"
}

variable "cert_manager_serviceaccount" {
  description = "Certificate manager service account"
  type        = string
  default     = "zbi-cert-manager-sa"
}

variable "cert_manager_namespace" {
  description = "Certificate manager namespace"
  type        = string
  default     = "cert-manager"
}

variable "csi_namespace" {
  description = "Namespace for the CSI driver"
  type        = string
  default     = "kube-system"
}

variable "enable_ebs_csi" {
  description = "Enable EBS CSI driver"
  type        = bool
  default     = true
}

variable "ebs_csi_role_name" {
  description = ""
  type        = string
  default     = "zbi-ebs-csi"
}

variable "ebs_csi_serviceaccount" {
  description = ""
  type        = string
  default     = "zbi-ebs-csi-sa"
}

variable "enable_efs_csi" {
  description = ""
  type        = bool
  default     = false
}

variable "efs_csi_role_name" {
  description = ""
  type        = string
  default     = "zbi-efs-csi"
}

variable "efs_csi_serviceaccount" {
  description = ""
  type        = string
  default     = "zbi-efs-csi-sa"
}

#**********************
#EKS Cluster settings
#***********************
variable "eks_cluster_version" {
  description = "The Kubernetes version to deploy"
  type        = string
  default     = "1.23"
}

variable "eks_root_volume_type" {
  description = "The root volume type for the EKS cluster"
  type        = string
  default     = "gp2"
}


variable "eks_enable_irsa" {
  description = "Flag to create OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default = true
}

variable "eks_cluster_log_retention_in_days" {
  description = "Log retention in days for the EKS cluster"
  type        = string
  default     = "7"
}

variable "eks_cluster_enabled_log_types" {
  description = "List of enabled log types for the EKS cluster"
  type        = list(string)
  default     = ["api", "audit"]
}

variable "eks_ec2_key_pair" {
  description = "The EC2 key pair for the instances in the cluster"
  type        = string
  default = "sandbox-ec2"
}

#       desired_capacity     = 2
#       max_capacity         = 2
#       min_capacity         = 2

#       disk_size            = 10

# #      instance_types        = ["t2.small"]

# #      ami_type             = "ami-09a67037138f86e67"
# #      instance_types        = ["t4g.xlarge"]

#       instance_types        = ["m5.xlarge"]


variable "eks_node_group_default_desired_capacity" {
  description = "Default desired capacity for the EKS node group"
  type        = number
  default     = 2
}

variable "eks_node_group_default_max_capacity" {
  description = ""
  type        = number
  default = 2
}

variable "eks_node_group_default_min_capacity" {
  description = ""
  type        = number
  default = 2
}

variable "eks_node_group_disk_size" {
  description = ""
  type        = number
  default = 10
}

variable "eks_node_group_default_instance_types" {
  description = ""
  type        = list(string)
  default = ["m5.xlarge"]
}

variable "eks_node_group" {
  description = ""
  type        = list(map(string))
  default     = [ {
    "desired_capacity" = "2"
    "max_capacity" = "2"
    "min_capacity" = "2"
  } ]
}

##################################
# ECR Settings
##################################

variable "ecr_repo_names" {
  description = "List ECR Repositories"
  type        = list(string)
  default     = ["zbi-controller"]
}

variable "ecr_repo_mutability" {
  description = "Mutability state for repository"
  type        = string
  default     = "IMMUTABLE"
}

variable "ecr_repo_scan" {
  description = "Scan image on push"
  type        = bool
  default     = true
}

