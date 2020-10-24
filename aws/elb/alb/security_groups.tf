resource "aws_security_group" "alb" {
  name        = var.service_name
  description = "Load balancer security group for service: ${var.service_name}"
  vpc_id      = var.subnets.vpc_id

  tags = merge(
    local.common_tags,
    {
      "Name" = format("%s_lb", var.service_name)
    },
  )
}

resource "aws_security_group_rule" "allow_all_http_inbound" {
  count             = var.internal ? 0 : 1
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from anywhere"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.source_ip_cidrs
}

resource "aws_security_group_rule" "allow_all_https_inbound" {
  count             = var.internal ? 0 : 1
  security_group_id = aws_security_group.alb.id
  description       = "HTTPS from anywhere"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.source_ip_cidrs
}

resource "aws_security_group_rule" "lb_allow_all_outbound" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow outbound traffic everywhere"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
