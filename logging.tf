resource "aws_cloudwatch_log_group" "app_ecs_logs" {
  name = "/ecs/${var.app_name}-${terraform.workspace}"

  tags = {
    Environment = terraform.workspace
    Application = var.app_name
  }
}

resource "aws_cloudtrail" "api_logs" {
  count = var.enable_cloudtrail ? 1 : 0
  name = "${var.app_name}-trail-${terraform.workspace}"
  s3_bucket_name = module.s3_log_bucket.this_s3_bucket_id
  s3_key_prefix = "cloudtrail"
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.app_cloudtrail_logs[0].arn
  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cloudwatch_access.arn
}

resource "aws_cloudwatch_log_group" "app_cloudtrail_logs" {
  count = var.enable_cloudtrail ? 1 : 0
  name = "/cloudtrail/${var.app_name}-${terraform.workspace}"

  tags = {
    Environment = terraform.workspace
    Application = var.app_name
  }
}