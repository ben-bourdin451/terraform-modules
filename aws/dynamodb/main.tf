resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key.name
  range_key    = var.range_key == null ? null : var.range_key.name

  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  point_in_time_recovery {
    enabled = var.enable_recovery
  }

  server_side_encryption {
    enabled = var.enable_server_side_encryption
  }

  dynamic "ttl" {
    for_each = var.enable_ttl ? [""] : []
    content {
      enabled = true
      attribute_name = "EXPIRY_TIME"
    }
  }

  stream_enabled   = var.enable_stream
  stream_view_type = var.stream_view_type

  # Attribute block for the hash key
  attribute {
    name = var.hash_key.name
    type = var.hash_key.type
  }

  # Only make the attribute block for the range key if we supplied one
  dynamic "attribute" {
    for_each = var.range_key == null ? [] : [var.range_key]
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.lsi
    content {
      name            = local_secondary_index.value.name
      range_key       = local_secondary_index.value.range_key
      projection_type = local_secondary_index.value.projection_type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.gsi
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = global_secondary_index.value.range_key
      read_capacity   = global_secondary_index.value.read_capacity
      write_capacity  = global_secondary_index.value.write_capacity
      projection_type = global_secondary_index.value.projection_type
    }
  }

  tags = merge(
  var.tags,
  {
    "Terraform" = "true"
  },
  )

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }
}
