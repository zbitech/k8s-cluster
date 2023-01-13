resource "aws_ecr_repository" "repo" {
  count = length(var.ecr_repo_names)
  name = var.ecr_repo_names[count.index]
  image_tag_mutability = var.ecr_repo_mutability
  image_scanning_configuration {
    scan_on_push = var.ecr_repo_scan
  }

  tags = merge(local.tags)
}
