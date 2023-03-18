# resource "null_resource" "docker_build" {
#   provisioner "local-exec" {
#     command     = "docker build -t backend_conduit ."
#     working_dir = "./modules/ecs_cluster/project_backend"
#   }
# }

# data "aws_caller_identity" "this" {}

# resource "null_resource" "docker_push" {
#   depends_on = [null_resource.docker_build]

#   provisioner "local-exec" {
#     command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.this.account_id}.dkr.ecr.${var.region}.amazonaws.com"
#   }

#   provisioner "local-exec" {
#     command = "docker tag backend_conduit ${data.aws_caller_identity.this.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}:backend_latest"
#   }

#   provisioner "local-exec" {
#     command = "docker push ${data.aws_caller_identity.this.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}:backend_latest"
#   }
# }
