

# Define um grupo de logs do CloudWatch com um nome baseado nas variáveis do projeto e do ambiente
resource "aws_cloudwatch_log_group" "ecs-log-group" {
  name = "/ecs/${var.project_name}-${var.env}-task-definition"
}