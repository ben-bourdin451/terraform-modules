module "cache" {
  source = "../"

  service_name               = "my-service"
  cluster_name               = "my-cache-cluster"
  description                = "My example redis cache cluster"
  number_cache_clusters      = 1
  node_type                  = "cache.t2.small"
  engine_version             = "5.0.5"
  vpc_id                     = data.aws_vpc.main.id
  subnet_group_name          = "my-service"
  security_group_ids         = [data.aws_security_group.elasticache.id]
  auth_token                 = "my_super_secret_auth_token"
  automatic_failover_enabled = false
}
