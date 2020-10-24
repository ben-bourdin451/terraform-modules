# ------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ------------------------------------------------------

variable "key_alias" {
  description = "The alias of the KMS CMK"
  type        = string
}

variable "administrator_arns" {
  description = "A list of ARNs that can administer this CMK"
  type        = list(string)
}

variable "key_description" {
  description = "A description for the intentded use of the CMK"
  type        = string
}

#-----------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ----------------------------------------------------

variable "key_deletion_window" {
  description = "The amount of time in days it will take for a scheduled key deletion"
  default     = 30
  type        = string
}

variable "allowed_service_arns" {
  description = "A list of service ARNs that can use encrypt & decrypt using this CMK. Cannot be left blank if 'aws_services' is unsupplied"
  type        = list(string)
  default     = null
}

variable "allowed_aws_services" {
  description = "A list of AWS services to use the CMK. Cannot be left blank if 'service_arns' is unsupplied"
  type        = list(string)
  default     = null
}

#-----------------------------------------------------
# LOCAL VARIABLES
# These parameters have reasonable defaults.
# ----------------------------------------------------

locals {
  # AllowAccessForKeyAdministrators
  administrator_arn_list = jsonencode(var.administrator_arns)

  # AllowUseOfTheKey
  service_arn      = var.allowed_service_arns != null ? { "AWS" = var.allowed_service_arns } : {}
  aws_service      = var.allowed_aws_services != null ? { "Service" = var.allowed_aws_services } : {}
  principal_values = jsonencode(merge(local.service_arn, local.aws_service))
}
