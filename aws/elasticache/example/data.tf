data "aws_vpc" "main" {
  filter {
    name   = "tag:main"
    values = ["true"]
  }
}

data "aws_security_group" "elasticache" {
  vpc_id = data.aws_vpc.main.id
  name   = "redis_elasticache_service"
}
