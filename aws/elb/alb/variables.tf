#----------------------------
# Required
#----------------------------
variable "service_name" {
  description = "Service name"
  type        = string
}

variable "subnets" {
  description = "The subnets to place the LB in"
  type = object({
    ids    = list(string),
    vpc_id = string
  })
}

variable "acm" {
  description = "The ACM cert ARN used to terminate HTTPS connections"
  type = object({
    arn = string
  })
}

#----------------------------
# Optional
#----------------------------
variable "internal" {
  description = "Defines whether the ALB should be internally facing. Defaults to false (public facing)"
  default     = false
  type        = bool
}

variable "enable_delete_protection" {
  description = "Whether to prevent being able to destroy the LB"
  default     = false
  type        = bool
}

variable "additional_security_groups" {
  description = "Any additional security groups to assign to the ALB"
  default     = []
  type = list(object({
    id = string
  }))
}

variable "source_ip_cidrs" {
  description = "Restrict IP CIDRs of the security group"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "lb_ssl_policy" {
  description = "The SSL policy to use on the SSL termination of the LB"
  default     = "ELBSecurityPolicy-FS-2018-06"
  type        = string
}

variable "additional_tags" {
  description = "Any additional tags that you may want your service to have"
  type        = map(string)
  default     = {}
}

variable "access_logs" {
  description = "(Optional) An Access Logs block. Defaults to null (no logs)."
  default     = null

  type = object({
    enabled = bool
    bucket  = string
    prefix  = string
  })
}

#----------------------------
# Local
#----------------------------

locals {
  common_tags = merge(
    {
      "Terraform" = "true"
      "Service"   = var.service_name
    },
    var.additional_tags
  )
}
