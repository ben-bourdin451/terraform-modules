data "aws_vpc" "main" {
  filter {
    name   = "tag:main"
    values = ["true"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Type = "public"
  }
}

data "aws_acm_certificate" "mydomain" {
  domain      = "*.mydomain.com"
  types       = ["AMAZON_ISSUED"]
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "myzone" {
  name = "mydomain.com"
}
