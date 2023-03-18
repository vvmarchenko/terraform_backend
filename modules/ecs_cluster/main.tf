# The module ESC cluster by Vladyslav Marchenko.

resource "aws_ecs_cluster" "this" {
  name = var.global_name
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.this.name
  }
}

resource "aws_ecs_capacity_provider" "this" {
  name = var.capacity_provider_name
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.this.arn
    managed_scaling {
      status = "ENABLED"
    }
  }
}

resource "aws_ecr_repository" "this" {
  name = var.global_name
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.ecr-policy.json
}

resource "aws_autoscaling_group" "this" {
  name                      = var.global_name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.desired_capacity
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.subnet_id
}

locals {
  user_data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config
    EOF
}

resource "aws_launch_template" "this" {
  name = var.launch_template_name
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
    }
  }
  image_id      = data.aws_ami.ecs.id
  instance_type = var.instance_type
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.ecs_cluster_asg.id
    ]
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }
  user_data = base64encode(local.user_data)
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.global_name}-ecs-instance-profile"
  role = aws_iam_role.this.name
}

resource "aws_security_group" "ecs_cluster_asg" {
  name_prefix = "${var.global_name}-ecs-cluster"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ecs_cluster_asg"
  }
}

