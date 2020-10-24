module "example" {
  source = "./.."

  key_alias       = "example_key"
  key_description = "some example key"

  administrator_arns = [
    data.aws_iam_role.admin.arn
  ]
  allowed_service_arns = [
    data.aws_iam_role.my_service.arn
  ]
  allowed_aws_services = [
    "sns.amazonaws.com",
    "sqs.amazonaws.com",
  ]
}
