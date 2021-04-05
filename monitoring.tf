resource "aws_cloudwatch_metric_alarm" "alb_5xx_count" {
  alarm_name          = "${var.app_name}-alb-5xx-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "2"
  alarm_actions       = [aws_sns_topic.alerting.arn]
  ok_actions          = [aws_sns_topic.alerting.arn]
  treat_missing_data  = "missing"
  dimensions = {
    LoadBalancer = module.alb.this_lb_arn_suffix
    TargetGroup  = element(module.alb.target_group_arn_suffixes, 0)
  }
}

resource "aws_sns_topic" "alerting" {
  name = "${var.app_name}-sns-alerting-topic-${terraform.workspace}"
}

resource "aws_sns_topic_subscription" "alerting_endpoint" {
  topic_arn = aws_sns_topic.alerting.arn
  protocol  = "email"
  endpoint  = var.alerting_email
}