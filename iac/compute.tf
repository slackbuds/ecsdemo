resource "aws_ecr_repository" "ecsdemo" {
  name                 = local.resource_full_name
  image_tag_mutability = var.ecr_image_immutability
  encryption_configuration {
    encryption_type = var.ecr_encryption_type
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
  tags         = local.tags
}

resource "aws_ecs_cluster" "ecsdemo" {
  name = local.resource_full_name
}
