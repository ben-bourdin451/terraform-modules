module "example" {
  source    = "../"
  repo_name = "example"

  additional_trusted_identities = [
    "arn:aws:iam::123456789012:root",
  ]

  additional_tags = {
    Service = "example"
  }
}
