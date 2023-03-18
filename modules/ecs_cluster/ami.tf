data "aws_ami" "ecs" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.*"]
  }
}
