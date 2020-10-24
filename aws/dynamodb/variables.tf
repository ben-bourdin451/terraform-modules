# ------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ------------------------------------------------------

variable "table_name" {
  description = "(Required) A unique name for your table."
  type        = string
}

variable "hash_key" {
  description = "(Required, Forces new resource) The attribute to use as the hash (partition) key."
  type = object({
    name = string
    type = string
  })
}


# ------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ------------------------------------------
variable "attributes" {
  description = <<EOF
(Required) List of additional nested attribute definitions.
Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data.
(Default: [])
EOF
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "billing_mode" {
  description = "(Optional) Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST. Defaults to PROVISIONED"
  type        = string
  default     = "PROVISIONED"
}

variable "write_capacity" {
  description = "Minimum number of write units for this table and GSIs. Defaults to 5."
  type = number
  default = 5
}

variable "read_capacity" {
  description = "Minimum number of read units for this table and GSIs. Defaults to 5."
  type = number
  default = 5
}

variable "range_key" {
  description = "(Optional, Forces new resource) The attribute to use as the range (sort) key. (Default: null)"
  type = object({
    name = string
    type = string
  })
  default = null
}

variable "lsi" {
  description = "(Optional, Forces new resource) Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource."
  type = list(object({
    name = string
    range_key = string
    projection_type = string
  }))
  default = []
}

variable "gsi" {
  description = "List of GSI maps. GSI are nested attributes that can contain: hash_key, range_key, read_capacity, write_capacity, projection_type."
  type = list(object({
    name = string
    write_capacity = number
    read_capacity = number
    hash_key = string
    range_key = string
    projection_type = string
  }))
  default = []
}

variable "enable_recovery" {
  description = "Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables. Defaults to true."
  type = bool
  default = true
}

variable "enable_stream" {
  description = "Indicates whether Streams are to be enabled (true) or disabled (false). Defaults to false."
  type = bool
  default = false
}

variable "stream_view_type" {
  description = "Used when stream is enabled: when an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  type = string
  default = ""
}

variable "enable_autoscaling" {
  description = "(Optional) Enable autoscaling for the table. This has no effect unless the billing mode of the table is PROVISIONED. Defaults to true"
  type        = bool
  default     = true
}

variable "autoscaling_read_min_capacity" {
  description = "The minimum capacity of the read units when autoscaling is enabled. Defaults to 5"
  type = number
  default = 5
}

variable "autoscaling_read_max_capacity" {
  description = "The maximum capacity the read units will autoscale to. Defaults to 3000 as a table will shard at anything above that number."
  type = number
  default = 3000
}

variable "autoscaling_read_target_utilization" {
  description = "The target value (%) to match for read capacity units. Defaults to 70%."
  type = number
  default = 70
}

variable "autoscaling_read_scale_in_cooldown" {
  description = "The amount of time, in seconds, after a scale down activity completes before another scale down activity can start. Defaults to 1200 or 20min."
  type = number
  default = 1200
}

variable "autoscaling_read_scale_out_cooldown" {
  description = "The amount of time, in seconds, after a scale up activity completes before another scale up activity can start. Defaults to 0."
  type = number
  default = 0
}

variable "autoscaling_write_min_capacity" {
  description = "The minimum capacity of the write units when autoscaling is enabled. Defaults to 5."
  type = number
  default = 5
}

variable "autoscaling_write_max_capacity" {
  description = "The maximum capacity the write units will autoscale to. Defaults to 1000 as a table will shard at anything above that number."
  type = number
  default = 1000
}

variable "autoscaling_write_target_utilization" {
  description = "The target value (%) to match for write capacity units. Defaults to 70%."
  type = number
  default = 70
}

variable "autoscaling_write_scale_in_cooldown" {
  description = "The amount of time, in seconds, after a scale down activity completes before another scale down activity can start. Defaults to 1200 or 20min."
  type = number
  default = 1200
}

variable "autoscaling_write_scale_out_cooldown" {
  description = "The amount of time, in seconds, after a scale up activity completes before another scale up activity can start. Defaults to 0."
  type = number
  default = 0
}

variable "gsi_autoscaling_read_max_capacity" {
  description = "The maximum capacity the read units will autoscale to for GSIs. Defaults to 3000 as a table will shard at anything above that number."
  type = number
  default = 3000
}

variable "gsi_autoscaling_write_max_capacity" {
  description = "The maximum capacity the write units will autoscale to for GSIs. Defaults to 1000."
  type = number
  default = 1000
}

variable "gsi_autoscaling_read_target_utilization" {
  description = "The target value (%) to match for GSI read capacity units. Defaults to 70%."
  type = number
  default = 70
}

variable "gsi_autoscaling_write_target_utilization" {
  description = "The target value (%) to match for GSI write capacity units. Defaults to 70%."
  type = number
  default = 70
}

variable "enable_ttl" {
  description = "Defines time to live attribute to clean up items from the table automatically. Forces the TTL attribute to be called EXPIRY_TIME. The value of this attribute must be in seconds."
  type = bool
  default = false
}

variable "enable_server_side_encryption" {
  description = "Whether to enable encryption at rest. Defaults to false."
  type = bool
  default = false
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type = map(string)
  default = {}
}

variable "region" {
  default = "eu-west-1"
  type = string
  description = "The AWS region where the alert will be created"
}

variable "enable_alarms" {
  description = "Whether or not to enable alarms for this table. Defaults to false."
  type = bool
  default = false
}

variable "alarm_period" {
  default = 60
  type = number
  description = "The period over which the metric will be measured (default = 60s)"
}

variable "alarm_sns_topic" {
  description = "The SNS topic to use for the alarms."
  type = string
  default = ""
}

variable "alarm_evaluation_period" {
  description = "The evaluation period for the alarms (Default: 1)"
  type = number
  default = 1
}

variable "alarm_threshold" {
  description = "The threshold above which to trigger the alarm (Default: 0)"
  type = number
  default = 0
}

# ------------------------------------------
# LOCAL VARIABLES
# For internal use only
# ------------------------------------------

locals {
  should_autoscale = var.enable_autoscaling && var.billing_mode == "PROVISIONED"
}
