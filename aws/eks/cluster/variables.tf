# ------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ------------------------------------------------------
variable "vpc_id" {
  description = "(Required) AWS VPC ID to create the cluster in."
  type        = string
}

variable "subnet_ids" {
  description = "(Required) List of AWS Subnet IDs to place the EKS cluster."
  type        = list(string)
}

variable "cluster_name" {
  description = "(Required) Name of the AWS EKS Cluster."
  type        = string
}

variable "cluster_version" {
  description = "(Required) EKS Kubernetes version."
  type        = string
}

# ------------------------------------------------------
# AWS Auth variables 
# ------------------------------------------------------
variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
  default     = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See README.md for example format."
  type        = list(
    object({
      role_arn = string
      username = string
      group = string
    })
  )
  default     = null
}

# ------------------------------------------------------
# OPTIONAL VARIABLES
# ------------------------------------------------------
variable "deployed" {
  description = "Enables/disables the following resources: ELB, ASG, LT and Route53. (Default: true)"
  type        = bool
  default     = true
}

variable "cloudwatch_retention" {
  description = "(Optional) Number of days to keep the cloudwatch logs. (Default: 14)"
  type        = number
  default     = 14
}

variable "public_endpoint" {
  description = "(Optional) Indicates whether or not the Amazon EKS public API server endpoint is enabled. (Default: true)"
  type        = bool
  default     = true
}

variable "private_endpoint" {
  description = "(Optional) Indicates whether or not the Amazon EKS private API server endpoint is enabled. (Default: false)"
  type        = bool
  default     = false
}

variable "cluster_log_types" {
  description = "A list of the desired control plane logging to enable. (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = []
}

variable "additional_tags" {
  description = "(Optional) Additional map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

# ------------------------------------------
# LOCAL VARIABLES
# ------------------------------------------
locals {
  worker_node = "eks-cluster-${var.cluster_name}-worker-node"
  common_tags = merge(var.additional_tags, local.tags)

  tags = {
    Kubernetes = "EKS"
    Terrraform = "true"
    Cluster    = var.cluster_name
  }
}
