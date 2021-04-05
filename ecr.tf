resource "aws_ecr_repository" "app" {
  name = "${var.app_name}-repo-${terraform.workspace}"

  tags = {
    Environment = terraform.workspace
    Application = var.app_name
  }
}