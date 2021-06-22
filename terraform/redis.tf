resource "aws_elasticache_cluster" "redis" {
  cluster_id           = local.family
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name = aws_elasticache_subnet_group.redis.name
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = local.family
  subnet_ids = data.aws_subnet_ids.subnets.ids
}