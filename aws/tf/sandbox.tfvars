name   = "zbi-sandbox"
region = "us-east-1"
environment = "sandbox"

vpc_cidr_block = "10.0.0.0/16"
vpc_private_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_public_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
vpc_sg_ingress_cidr = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
enable_nat_gateway = true
single_nat_gateway = true
enable_dns_hostnames = true

dns_manager_role_name = "dns-manager"
enable_cert_manager = true
cert_manager_serviceaccount = "zbi-cert-manager-sa"
cert_manager_namespace = "cert-manager"
csi_namespace = "kube-system"
enable_ebs_csi = true
ebs_csi_role_name = "zbi-ebs-csi"
ebs_csi_serviceaccount = "ebs-csi-controller-sa"
enable_efs_csi = false
efs_csi_role_name = "zbi-efs-csi"
efs_csi_serviceaccount = "efs-csi-controller-sa"

eks_cluster_version = "1.23"
eks_root_volume_type = "gp2"
eks_enable_irsa = true
eks_cluster_log_retention_in_days = 3
eks_cluster_enabled_log_types = ["api", "audit"]
eks_ec2_key_pair = "sandbox-ec2"

eks_node_group_default_desired_capacity = 2
eks_node_group_default_max_capacity = 2
eks_node_group_default_min_capacity = 2
eks_node_group_disk_size = 10
eks_node_group_default_instance_types = ["m5.xlarge"]
eks_node_group = [{
  "desired_capacity" = 2
  "max_capacity" = 2
  "min_capacity" = 2
}]

ecr_repo_names = ["zbi-controller", "zbi-dashboard"]
ecr_repo_mutability = "MUTABLE"
ecr_repo_scan = false
