resource "aws_lb" "http" {
  name               = replace(var.service_name, "_", "-")
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.subnets.ids
  security_groups = concat(
    [aws_security_group.alb.id],
    compact(var.additional_security_groups.*.id)
  )

  enable_deletion_protection = var.enable_delete_protection

  dynamic "access_logs" {
    for_each = var.access_logs != null ? [var.access_logs] : []
    content {
      enabled = var.access_logs.enabled
      bucket  = var.access_logs.bucket
      prefix  = var.access_logs.prefix
    }
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.http.arn
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

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.http.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.lb_ssl_policy
  certificate_arn   = var.acm.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<p><i>What's down here?</i></p><p><i>Just raw, infinite subconscious. Nothing is down here. Except for whatever that might have been left behind by whoever's running the code who was trapped down here before. Which in our case, is just you.</i></p><p>You hit limbo of the load balancer, there's nothing here</p>"
      status_code  = "404"
    }
  }
}
