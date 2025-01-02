output "ecr" {
  value = aws_ecr_repository.ecsdemo.arn
}

output "ecs_cluster" {
  value = aws_ecs_cluster.ecsdemo.arn
}

output "ecs_task_definition" {
  value = aws_ecs_task_definition.ecsdemo.arn
}

output "target_group" {
  value = aws_lb_target_group.ecsdemo.arn
}

# output "ecs_service" {
#   value = aws_ecs_service.ecsdemo.id
# }

output "access_logs" {
  value = aws_s3_bucket.access_logs.arn
}

output "alb" {
  value = aws_lb.ecsdemo.id
}
