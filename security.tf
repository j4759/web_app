locals {
  allow_list = [ var.allowlist_cidr ]
}

resource "aws_security_group" "lb" {
  name        = "${var.app_name}-lb-sg-${terraform.workspace}"
  description = "Restricts access to ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = local.allow_list
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_name}-ecs-tasks-sg-${terraform.workspace}"
  description = "allow access to ECS from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "ALB access to task"
    from_port       = 0
    security_groups = [aws_security_group.lb.id]
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}