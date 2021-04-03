module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = "${var.app_name}-alb-${terraform.workspace}"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.lb.id]

  access_logs = {
    bucket = module.s3_log_bucket.this_s3_bucket_id
  }

  target_groups = [{
    name             = "${var.app_name}-alb-tg-${terraform.workspace}"
    backend_protocol = "HTTP"
    backend_port     = 80
    target_type      = "ip"
  }]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Application = var.app_name
    Environment = terraform.workspace
  }
}