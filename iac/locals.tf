locals {
  resource_full_name      = format("ecsdemo-%s", var.env)
  ecs_security_group      = format("%s-ecs", local.resource_full_name)
  elb_security_group      = format("%s-elb", local.resource_full_name)
  ecs_task_execution_role = format("%s-task-execution", local.resource_full_name)
  ecs_execution_role      = format("%s-execution", local.resource_full_name)
  bucket_name_access_logs = format("%s-access-logs", local.resource_full_name)
  tags = {
    env = var.env
  }
}
