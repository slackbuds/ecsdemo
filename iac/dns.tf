data "aws_route53_zone" "ecsdemo" {
  name = "slackbuds.io."
}

resource "aws_route53_record" "ecsdemo" {
  zone_id = data.aws_route53_zone.ecsdemo.zone_id
  name    = "ecsdemo.slackbuds.io"
  type    = "A"
  alias {
    evaluate_target_health = true
    name                   = aws_lb.ecsdemo.dns_name
    zone_id                = aws_lb.ecsdemo.zone_id
  }
}
