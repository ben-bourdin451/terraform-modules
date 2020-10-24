variable "service_name" {
  type        = string
  description = "(Required) High level service name that your ES cluster belongs to."
}

variable "cluster_name" {
  type        = string
  description = "(Required) The replication group identifier"
}

variable "description" {
  type        = string
  description = "(Required) A user-created description for the replication group"
}

variable "node_type" {
  type        = string
  description = "(Required) The node type e.g. cache.t2.small"
}

variable "engine_version" {
  type        = string
  description = "(Required) The version number of the cache engine to be used for the cache clusters in this replication group"
}

variable "number_cache_clusters" {
  type        = number
  description = "(Required) The number of cache clusters (primary and replicas) this replication group will have"
}

variable "automatic_failover_enabled" {
  type        = bool
  description = "(Required) If true, number_cache_clusters must be >= 2"
}

variable "subnet_group_name" {
  type        = string
  description = "(Required) The name of the elasticache subnet group to create"
}

variable "vpc_id" {
  type        = string
  description = "(Required) The id of the VPC to use in order to locate the subnets this cluster is going to be created in"
}

variable "auth_token" {
  type        = string
  description = "(Required) The password used to access a password protected server"
}

variable "security_group_ids" {
  type        = set(string)
  description = "(Optional) A list of cache security group names to associate with this replication group"
  default     = []
}

variable "engine" {
  type        = string
  description = "(Optional) The name of the cache engine to be used for the clusters in this replication group; defaults to redis"
  default     = "redis"
}

variable "port" {
  type        = number
  description = "(Optional) The port number on which each of the cache nodes will accept connections; defaults to 6379"
  default     = 6379
}

variable "additional_tags" {
  type        = map(string)
  description = "A map of tags (key-value pairs) passed to resources"
  default     = {}
}

locals {
  common_tags = merge(var.additional_tags, local.tags)

  tags = {
    Terraform = "true"
    Servirce  = var.service_name
  }
}
