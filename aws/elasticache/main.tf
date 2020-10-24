resource "aws_elasticache_subnet_group" "private" {
  name       = var.subnet_group_name
  subnet_ids = data.aws_subnet_ids.private.ids
}

resource "aws_elasticache_replication_group" "cache_cluster" {
  replication_group_id          = var.cluster_name
  replication_group_description = var.description
  number_cache_clusters         = var.number_cache_clusters
  node_type                     = var.node_type
  engine                        = var.engine
  engine_version                = var.engine_version
  port                          = var.port
  security_group_ids            = var.security_group_ids
  subnet_group_name             = aws_elasticache_subnet_group.private.name

  # At-rest/In-transit encryption enabled by default
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  # Whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails
  automatic_failover_enabled = var.automatic_failover_enabled

  # Require an auth token (since transit_encryption_enabled = true)
  auth_token = var.auth_token

  # Can result in a brief downtime as servers reboots
  apply_immediately = true

  tags = local.common_tags
}
