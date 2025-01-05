data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_subnets" "ecsdemo" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_route53_zone" "ecsdemo" {
  name = "slackbuds.io."
}
