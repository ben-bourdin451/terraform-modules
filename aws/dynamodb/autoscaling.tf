data "aws_iam_role" "aws_dynamodb_autoscaling_role" {
  name = "AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
}

resource "aws_appautoscaling_target" "table_read_target" {
  count              = local.should_autoscale ? 1 : 0
  min_capacity       = var.autoscaling_read_min_capacity
  max_capacity       = var.autoscaling_read_max_capacity
  resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}"
  role_arn           = data.aws_iam_role.aws_dynamodb_autoscaling_role.arn
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_read_policy" {
  count              = local.should_autoscale ? 1 : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.table_read_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_read_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_read_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_read_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value       = var.autoscaling_read_target_utilization
    scale_in_cooldown  = var.autoscaling_read_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_read_scale_out_cooldown
  }
}

resource "aws_appautoscaling_target" "table_write_target" {
  count              = local.should_autoscale ? 1 : 0
  min_capacity       = var.autoscaling_write_min_capacity
  max_capacity       = var.autoscaling_write_max_capacity
  resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}"
  role_arn           = data.aws_iam_role.aws_dynamodb_autoscaling_role.arn
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "table_write_policy" {
  count              = local.should_autoscale ? 1 : 0
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.table_write_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_write_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.table_write_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.table_write_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value       = var.autoscaling_write_target_utilization
    scale_in_cooldown  = var.autoscaling_write_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_write_scale_out_cooldown
  }
}

# GSI Scaling
# --- WARNING ---
# Due to an issue with Terraform, autoscaling GSIs will show a diff in the plan if the capacities don't match up.
# Be careful when applying and modify original capacities to prevent capacity changes if needed
# https://github.com/terraform-providers/terraform-provider-aws/issues/671

resource "aws_appautoscaling_target" "gsi_read_targets" {
  count              = local.should_autoscale ? length(var.gsi) : 0
  min_capacity       = var.gsi[count.index]["read_capacity"]
  max_capacity       = var.gsi_autoscaling_read_max_capacity
  resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}/index/${var.gsi[count.index]["name"]}"
  role_arn           = data.aws_iam_role.aws_dynamodb_autoscaling_role.arn
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "gsi_read_policies" {
  count              = local.should_autoscale ? length(var.gsi) : 0
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.gsi_read_targets[count.index].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.gsi_read_targets[count.index].resource_id
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value       = var.gsi_autoscaling_read_target_utilization
    scale_in_cooldown  = var.autoscaling_read_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_read_scale_out_cooldown
  }
}

resource "aws_appautoscaling_target" "gsi_write_targets" {
  count              = local.should_autoscale ? length(var.gsi) : 0
  min_capacity       = var.gsi[count.index]["write_capacity"]
  max_capacity       = var.gsi_autoscaling_write_max_capacity
  resource_id        = "table/${aws_dynamodb_table.dynamodb_table.name}/index/${var.gsi[count.index]["name"]}"
  role_arn           = data.aws_iam_role.aws_dynamodb_autoscaling_role.arn
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "gsi_write_policies" {
  count              = local.should_autoscale ? length(var.gsi) : 0
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.gsi_write_targets[count.index].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.gsi_write_targets[count.index].resource_id
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value       = var.gsi_autoscaling_write_target_utilization
    scale_in_cooldown  = var.autoscaling_write_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_write_scale_out_cooldown
  }
}

