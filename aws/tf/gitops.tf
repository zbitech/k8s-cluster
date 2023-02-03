
resource "null_resource" "gitops" {
    provisioner "local-exec" {
        command = "/bin/bash scripts/gitops.sh"    
 #       interpreter = ["/bin/bash"]
    }

    depends_on = [module.eks]
}