# ------------------------------------------------------
# REQUIRED PARAMETERS
# ------------------------------------------------------
variable "vpc_id" {
  description = "(Required) AWS VPC ID to create the cluster in."
  type        = string
}

variable "subnet_ids" {
  description = "(Required) List of AWS Subnet IDs to place the EKS node nodes."
  type        = list(string)
}

variable "cluster_name" {
  description = "(Required) AWS EKS Cluster name."
  type        = string
}

variable "cluster_version" {
  description = "(Required) Determines which EKS AMI to use."
  type        = string
}

variable "cluster_endpoint" {
  description = "(Required) AWS EKS Cluster endpoint."
  type        = string
}

variable "cluster_ca" {
  description = "(Required) Base64 encoded certificate authority data of the cluster."
  type        = string
}

variable "name" {
  description = "(Required) AWS EKS Cluster name."
  type        = string
}

variable "instance_profile" {
  description = "(Required) AWS IAM Instance profile name for the worker nodes inside the Cluster."
  type        = string
}

variable "security_group" {
  description = "(Required) AWS Security group name for the worker node inside the Cluster."
  type        = string
}

variable "instance_type" {
  description = "(Required) Autoscaling group instance type."
  type        = string
}

variable "autoscaling_enabled" {
  description = "(Required) Enables/disables node autoscaling."
  type        = string
}

# ------------------------------------------
# OPTIONAL PARAMETERS
# ------------------------------------------
variable "deployed" {
  description = "Enables/disables the following resources: ELB, ASG, LT and Route53. (Default: true)"
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "(Optional) AWS Instance is EBS optimized or not. (Default: true)"
  type        = bool
  default     = true
}

variable "volume_size" {
  description = "(Optional) Volume size for each intance in the Auto Scaling Group. (Default: 20)"
  type        = number
  default     = 20
}

variable "key_pair" {
  description = "(Optional) SSH Keypair to use on the instances. (Default: none)"
  type        = string
  default     = ""
}

variable "ami_release_date" {
  description = "(Optional) Optionally restrict which AMI gets selected. E.g.: 20190329 (Default value: *)"
  type        = string
  default     = "*"
}

variable "max_size" {
  description = "(Optional) Maximum size of the auto scaling group. (Default: 5)"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "(Optional) Minimum size of the auto scaling group. (Default: 1)"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "(Optional) Desired size of the auto scaling group. (Default: 3)"
  type        = number
  default     = 3
}

variable "additional_security_group_ids" {
  description = "(Optional) Additional security group IDs to assign for the worker nodes."
  type        = list(string)
  default     = []
}

variable "pre_bootstrap_script" {
  description = "(Optional) Additional script to run before bootstrapping the worker node."
  type        = string
  default     = ""
}

variable "bootstrap_extra_args" {
  description = "(Optional) Extra arguments passed to the bootstrap.sh script from the EKS AMI. (Script: https://github.com/awslabs/amazon-eks-ami/blob/master/files/bootstrap.sh)"
  type        = string
  default     = ""
}

variable "post_bootstrap_script" {
  description = "(Optional) Additional script to run after bootstrapping the worker node."
  type        = string
  default     = ""
}

variable "kubelet_extra_args" {
  description = "(Optional) Additional arguments to start kubelet on the instances. (Check https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/ for more info.)"
  type        = string
  default     = ""
}

variable "node_labels" {
  description = "(Optional) List of labels to assign to each worker node, which can be used as nodeSelectors."
  type        = list(string)
  default     = []
}

variable "additional_tags" {
  description = "(Optional) Additional map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------
# LOCAL VARIABLES
# ------------------------------------------------------
locals {
  name         = "eks-cluster-${var.cluster_name}-${var.name}-worker-group"
  node_labels  = length(var.node_labels) != 0 ? "--node-labels='${join(",", var.node_labels)}'" : ""
  kubelet_args = length(var.node_labels) != 0 ? "${var.kubelet_extra_args} ${local.node_labels}" : var.kubelet_extra_args
}
