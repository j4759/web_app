resource "aws_cloudwatch_log_group" "app_ecs_logs" {
  name = "/ecs/${var.app_name}-${terraform.workspace}"

  tags = {
    Environment = terraform.workspace
    Application = var.app_name
  }
}
