resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role_terra"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]


  inline_policy {
    name = "this_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "kms:Decrypt",
            "ssm:GetParametersByPath",
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          Effect = "Allow",
          Resource = [
            "arn:aws:ssm:us-east-1:734507832483:parameter/hillel/conduit/db/*",
            "arn:aws:kms:us-east-1:734507832483:key/2fc8f4e7-9a7c-4dae-9938-dedaa51b1a5d"
          ]
        }
      ]
    })
  }
}

