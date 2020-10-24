# ------------------------------------------
# REQUIRED PARAMETERS
# ------------------------------------------
variable "repo_name" {
  description = "The name of the repository you wish to create"
  type        = string
}

# ------------------------------------------
# OPTIONAL PARAMETERS
# ------------------------------------------
variable "additional_trusted_identities" {
  description = "A list of trusted identities that can interact with the repository, for example: 'arn:aws:iam::123456789012:root' for an account or 'arn:aws:iam::123456789012:user/name' for a user. By default the root caller identity is trusted"
  type        = list(string)
  default     = []
}

variable "additional_tags" {
  description = "(Optional) Additional tags to add to resources. (Default: {})"
  type        = map(string)
  default     = {}
}

variable "immutable_tags" {
  description = "(Optional) Enables immutable tags if set to true. (Default: true)"
  type        = bool
  default     = true
}

# ------------------------------------------
# LOCAL VARIABLES
# ------------------------------------------
data "aws_caller_identity" "current" {}

locals {
  # Default trusted identities to at least the called identity
  trusted_identities = jsonencode(
    concat([format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)], compact(var.additional_trusted_identities))
  )

  base_tags = {
    Terraform = "true"
  }

  common_tags = merge(local.base_tags, var.additional_tags)
}
