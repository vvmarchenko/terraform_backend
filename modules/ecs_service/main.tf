# The module ESC service by Vladyslav Marchenko.

resource "aws_lb" "this" {
  name               = var.global_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_id
}

resource "aws_lb_target_group" "this" {
  name        = var.global_name
  port        = var.tg_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

data "aws_caller_identity" "this" {}

resource "aws_ecs_task_definition" "this" {
  lifecycle {
    ignore_changes = all
  }
  family       = var.global_name
  network_mode = "bridge"
  memory       = 900
  container_definitions = jsonencode([
    {
      name  = "${var.global_name}"
      image = "${var.repository_url}:backend_latest"
      links = ["database:database"]
      portMappings = [{
        containerPort = var.container_port
        protocol      = "tcp"
      }]
      essensial = true
      environment = [
        {
          name  = "DATABASE_HOST"
          value = "database"
        },
        {
          name  = "PORT"
          value = tostring(var.container_port)
        }
      ]
      secrets = [
        {
          name      = "ACCESS_TOKEN_SECRET"
          valueFrom = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.this.account_id}:parameter/${var.resource_name}/ACCESS_TOKEN_SECRET"
        },
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.this.account_id}:parameter/${var.resource_name}/DATABASE_PASSWORD"
        },
        {
          name      = "DATABASE_USER"
          valueFrom = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.this.account_id}:parameter/${var.resource_name}/DATABASE_USER"
        }
      ]
    },
    {
      name  = "database"
      image = "mongo:6"
      secrets = [
        {
          name      = "MONGO_INITDB_ROOT_USERNAME"
          valueFrom = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.this.account_id}:parameter/${var.resource_name}/DATABASE_USER"
        },
        {
          name      = "MONGO_INITDB_ROOT_PASSWORD"
          valueFrom = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.this.account_id}:parameter/${var.resource_name}/DATABASE_PASSWORD"
        }
      ]
    }
  ])
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["EC2"]
  depends_on = [
    aws_iam_role.ecs_task_execution_role
  ]
}

resource "aws_ecs_service" "this" {
  name            = var.global_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  capacity_provider_strategy {
    capacity_provider = var.aws_ecs_capacity_provider
    weight            = 1
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.global_name
    container_port   = var.container_port
  }
  depends_on = [
    aws_ecs_task_definition.this
  ]
}

