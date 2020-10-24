# ------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ------------------------------------------------------

variable "service_name" {
  description = "(Required) High level service name that your Lambda Function belongs to."
  type        = string
}

variable "function_name" {
  description = "(Required) A unique name for your Lambda Function."
  type        = string
}

variable "filename" {
  description = "(Required) The path to the function's deployment package within the local filesystem."
  type        = string
}

variable "handler" {
  description = "(Required) The function entrypoint in your code."
  type        = string
}

variable "runtime" {
  description = "(Required) See Runtimes for valid values."
  type        = string
}

variable "lambda_iam_role" {
  description = "(Required) IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to."
  type = object({
    name = string
    arn  = string
  })
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "description" {
  description = "Description of what your Lambda Function does"
  default     = ""
  type        = string
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128"
  default     = 128
  type        = number
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 300"
  default     = 300
  type        = number
}

variable "kms_key" {
  description = "The ARN for the KMS encryption key."
  default     = null
  type = object({
    arn = string
  })
}

variable "env_vars" {
  description = "Map of environment variables."
  default     = null
  type        = map(any)
}

variable "vpc_config" {
  description = "The configurations for a VPC enabled lambda"
  default     = null
  type = object({
    subnet_ids = list(string),
    security_groups = list(object({
      id = string
    }))
  })
}

variable "tracing_mode" {
  description = "Can be either PassThrough or Active. If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with 'sampled=1'. If Active, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision."
  default     = "PassThrough"
  type        = string
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events for this lambda."
  default     = 14
  type        = number
}

variable "additional_tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  default     = {}
  type        = map(string)
}

locals {
  common_tags = merge(
    {
      "Terraform" = "true"
      "Service"   = var.service_name
    },
    var.additional_tags
  )
}
