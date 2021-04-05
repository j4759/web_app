locals {
  container_name = "${var.app_name}-task"
}

resource "aws_ecs_cluster" "app" {
  name               = "${var.app_name}-${terraform.workspace}"
  capacity_providers = ["FARGATE"]

  tags = {
    "Name" = "${var.app_name}-${terraform.workspace}"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-task-definition-${terraform.workspace}"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "${var.deployment_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.app_name}-rep-${terraform.workspace}:latest"
      essential = true
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.app_ecs_logs.name,
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "ecs"
        }
      },
      portMappings = [
        {
          containerPort = var.task_container_port
          protocol      = "tcp"
        }
      ]

    }
  ])
  depends_on = [
    aws_ecr_repository.app
  ]
}


resource "aws_ecs_service" "app" {
  name                              = "${var.app_name}-ecs-service-${terraform.workspace}"
  cluster                           = aws_ecs_cluster.app.id
  task_definition                   = aws_ecs_task_definition.app.arn
  desired_count                     = var.task_desired_count
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 30

  load_balancer {
    target_group_arn = element(module.alb.target_group_arns, 0)
    container_name   = local.container_name
    container_port   = 80
  }

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [module.alb]
}
