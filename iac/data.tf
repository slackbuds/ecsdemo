data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_subnets" "current" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_route53_zone" "current" {
  name = "slackbuds.io."
}
