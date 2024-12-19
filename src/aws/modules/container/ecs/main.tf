resource "aws_ecs_cluster" "default" {
  name = "${var.project_name}-${var.environment}-cluster"  
}

resource "aws_ecs_task_definition" "default" {
  family = "${var.project_name}-${var.environment}-td" 
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
  
  # container_definitions = templatefile("${path.module}/task_definitions.json", {
  #   "container_name": "${var.project_name}-${var.environment}-con"
  # })

  container_definitions = jsonencode(
      [
        {
            "name": "${var.project_name}-${var.environment}-con",
            "image": "gkoenig/simplehttp",
            "environment": [
              {"name": "message", "value": "Uhuuuuu"}
            ],
            "essential": true,
            "portMappings": [{
            "containerPort": 8000,
            "hostport": 8000,
            "protocol": "tcp",
            "appProtocol": "http"
            }]
        }
    ]
  )
}


resource "aws_ecs_service" "default" {  
  name = "${var.project_name}-${var.environment}-svc" 
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.default.arn
  desired_count   = 1
  force_new_deployment = true

  # Define configurações de rede para o serviço ECS
  network_configuration {
    assign_public_ip = true
    subnets          = [var.public_subnets[0].id]                      
    security_groups  = [var.security_group_id] 
  }  

  # ordered_placement_strategy {
  #   type  = "binpack"
  #   field = "cpu"
  # }

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.foo.arn
  #   container_name   = "mongo"
  #   container_port   = 8080
  # }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }
}