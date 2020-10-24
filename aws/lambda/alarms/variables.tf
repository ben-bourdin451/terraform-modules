# ------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ------------------------------------------------------

variable "service_name" {
  description = "(Required) High level service name that your alarms belongs to."
  type        = string
}

variable "function" {
  description = "(Required) The function for which the alarms will be created"
  type = object({
    function_name = string
  })
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "enabled" {
  description = "Deploy all resources created as part of this module. Defaults to true"
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  default     = {}
  type        = map(string)
}

variable "enable_iterator_age_alarm" {
  description = "Enable iterator age alarm. Only use this if your lambda function is triggered by a Kinesis stream"
  default     = false
  type        = bool
}

variable "alias" {
  description = <<EOF
Optional alias label to use as a target of the alarm or what version of the lambda metrics you wish to alarm on.
Defaults to nothing, which implies it will track the UNVERSIONED function metrics.
EOF
  type = object({
    name = string
  })
  default = null
}


variable "sns_topic" {
  description = "SNS topic to which to send the alarm notifications."
  type = object({
    arn = string
  })
  default = null
}

locals {
  common_tags = merge(
    {
      Terraform = "true",
      Service = var.service_name,
    },
    var.additional_tags
  )
}
