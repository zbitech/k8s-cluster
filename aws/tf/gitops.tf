

resource "null_resource" "zbi-charts3" {
    provisioner "local-exec" {
        command = "aws eks update-kubeconfig --name zbi-sandbox --kubeconfig $(pwd)/kubeconfig --verbose"
    }

    provisioner "local-exec" {
        command = <<-EOT
          export KUBECONFIG=$(pwd)/kubeconfig
          helmfile/install-charts.sh
        EOT
        environment = {
          PROVIDER = "aws"
          AWS_REGION = var.region
          CERT_MANAGER_ROLE = aws_iam_role.cert-manager[0].arn
          EBS_CSI_ROLE = aws_iam_role.ebs-csi-role[0].arn
        }
    }

    # provisioner "local-exec" {
    #     command = "scripts/gitops.sh"    
    #     environment = {
    #       PROVIDER = "aws"
    #       KUBECONFIG = "$(pwd)/kubeconfig"
    #     }
    # }

    depends_on = [module.eks]
}