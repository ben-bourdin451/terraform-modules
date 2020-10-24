data "aws_iam_role" "admin" {
  name = "admin"
}

data "aws_iam_role" "my_service" {
  name = "my_service"
}
