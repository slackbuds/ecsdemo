# kms key
# secrets

resource "aws_ecr_repository" "ecsdemo" {
  name                 = local.resource_full_name
  image_tag_mutability = "IMMUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

resource "aws_ecs_cluster" "ecsdemo" {
  name = local.resource_full_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecsdemo" {
  family                   = "ecsdemo-family"
  task_role_arn            = aws_iam_role.ecsdemo_execution.arn
  execution_role_arn       = aws_iam_role.ecsdemo_task_execution.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name        = "ecsdemo-container"
      image       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/ecsdemo-dev:latest"
      essential   = true
      cpu         = 256
      memory      = 512
      networkMode = "awsvpc"
      portMappings = [{
        containerPort = 8080
        hostPort      = 8080
        protocol      = "tcp"
      }]
      environment = [
        {
          "name" : "foo",
          "value" : "bar"
        },
        {
          "name" : "JAVA_OPTS",
          "value" : "-Dspring.profiles.active=deploy"
        }
      ]
      secrets = [
        {
          "name" : "secret",
          "valueFrom" : var.secret_arn
        }
      ]
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-group         = "/aws/ecs/ecsdemo-family"
          mode                  = "non-blocking"
          awslogs-create-group  = "true"
          max-buffer-size       = "10m",
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = "ecsdemo"
        }
      }
      runtimePlatform : {
        cpuArchitecture : "X86_64",
        operatingSystemFamily : "linux"
      }
    }
  ])
}

resource "aws_s3_bucket" "access_logs" {
  bucket = local.bucket_name_access_logs
}

resource "aws_security_group" "ecsdemo_ecs" {
  name   = local.ecs_security_group
  vpc_id = var.vpc_id
}

resource "aws_security_group" "ecsdemo_elb" {
  name   = local.elb_security_group
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecsdemo_elb" {
  security_group_id = aws_security_group.ecsdemo_elb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_vpc_security_group_egress_rule" "ecsdemo_elb" {
  security_group_id = aws_security_group.ecsdemo_elb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_vpc_security_group_ingress_rule" "ecsdemo_ecs_from_elb" {
  security_group_id            = aws_security_group.ecsdemo_ecs.id
  referenced_security_group_id = aws_security_group.ecsdemo_elb.id
  ip_protocol                  = -1
}

resource "aws_vpc_security_group_egress_rule" "ecsdemo_ecs" {
  security_group_id = aws_security_group.ecsdemo_ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_lb_target_group" "ecsdemo" {
  name        = local.resource_full_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path     = "/actuator/health"
    port     = "8080"
    protocol = "HTTP"
  }
}

resource "aws_lb" "ecsdemo" {
  name               = local.resource_full_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecsdemo_elb.id]
  subnets            = data.aws_subnets.current.ids
  access_logs {
    bucket = aws_s3_bucket.access_logs.id
  }
}

resource "aws_lb_listener" "ecsdemo_http" {
  load_balancer_arn = aws_lb.ecsdemo.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "ecsdemo_https" {
  load_balancer_arn = aws_lb.ecsdemo.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecsdemo.arn
  }
}

resource "aws_ecs_service" "ecsdemo" {
  name            = local.resource_full_name
  cluster         = aws_ecs_cluster.ecsdemo.id
  task_definition = aws_ecs_task_definition.ecsdemo.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnets.current.ids
    security_groups  = [aws_security_group.ecsdemo_ecs.id]
    assign_public_ip = true
  }
  load_balancer {
    container_name   = "ecsdemo-container"
    container_port   = 8080
    target_group_arn = aws_lb_target_group.ecsdemo.arn
  }
}
