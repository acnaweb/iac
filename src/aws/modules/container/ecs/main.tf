resource "aws_ecs_cluster" "default" {
  name = "${var.project_name}-${var.environment}-cluster"
}

resource "aws_ecs_task_definition" "task-nginx" {
  family = "deploy-nginx"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = "arn:aws:iam::808769198378:role/ecsTaskExecutionRole"
  task_role_arn = "arn:aws:iam::808769198378:role/ecsTaskExecutionRole"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = <<TASK_DEFINITION
  [
    {
      "name": "nginx",
      "image": "nginx",      
      "essential": true,
      "portMappings": [
        {
        "containerPort": 80,
        "hostPort": 80
        }
      ]
    }
  ]
  TASK_DEFINITION
}