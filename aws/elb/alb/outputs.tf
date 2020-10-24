output "alb" {
  value = aws_lb.http
}

output "lb_https_listener" {
  value = aws_lb_listener.https
}

output "sg" {
  value = aws_security_group.alb
}
