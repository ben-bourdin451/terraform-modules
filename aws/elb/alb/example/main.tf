module "example" {
  source = "../"

  service_name = "example_alb"
  subnets      = data.aws_subnet_ids.public
  acm          = data.aws_acm_certificate.mydomain
}

module "example_with_logs" {
  source = "../"

  service_name = "example_alb_with_logs"
  subnets      = data.aws_subnet_ids.public
  acm          = data.aws_acm_certificate.mydomain

  access_logs = {
    bucket  = aws_s3_bucket.access_logs.bucket
    prefix  = local.access_logs_prefix
    enabled = true
  }
}

resource "aws_route53_record" "example" {
  zone_id = data.aws_route53_zone.myzone.zone_id
  name    = "http-alb.mydomain.com"
  type    = "A"

  alias {
    name                   = module.example.alb.dns_name
    zone_id                = module.example.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener_rule" "some_rule" {
  listener_arn = module.example.lb_https_listener.arn

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "It works! But there's nothing here"
      status_code  = "404"
    }
  }

  condition {
    field  = "host-header"
    values = [aws_route53_record.example.fqdn]
  }
}
