data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_demo_task_execution" {
  name               = local.ecs_task_execution_role
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

data "aws_iam_policy" "ecsdemo_task_execution_ecs" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecsdemo_task_execution_ecs" {
  role       = aws_iam_role.ecs_demo_task_execution.name
  policy_arn = data.aws_iam_policy.ecsdemo_task_execution_ecs.arn
}

data "aws_iam_policy_document" "ecsdemo_policy_task_execution" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
    ]
  }
}

resource "aws_iam_policy" "ecsdemo_task_execution" {
  name   = local.ecs_task_execution_role
  policy = data.aws_iam_policy_document.ecsdemo_policy_task_execution.json
}

resource "aws_iam_role_policy_attachment" "ecsdemo_task_execution" {
  role       = aws_iam_role.ecs_demo_task_execution.name
  policy_arn = aws_iam_policy.ecsdemo_task_execution.arn
}

resource "aws_iam_role" "ecs_demo_execution" {
  name               = local.ecs_execution_role
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

data "aws_iam_policy_document" "ecsdemo_policy_execution" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:ListTables"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }
}

resource "aws_iam_policy" "ecsdemo_execution_ecs" {
  name   = local.ecs_execution_role
  policy = data.aws_iam_policy_document.ecsdemo_policy_execution.json
}

resource "aws_iam_role_policy_attachment" "ecsdemo_execution" {
  role       = aws_iam_role.ecs_demo_execution.name
  policy_arn = aws_iam_policy.ecsdemo_execution_ecs.arn
}
