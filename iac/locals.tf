locals {
  resource_full_name      = "ecsdemo-${var.env}"
  ecs_security_group      = "${local.resource_full_name}-ecs"
  elb_security_group      = "${local.resource_full_name}-elb"
  ecs_task_execution_role = "${local.resource_full_name}-task-execution"
  ecs_execution_role      = "${local.resource_full_name}-execution"
  bucket_name_access_logs = "${local.resource_full_name}-access-logs"
}
