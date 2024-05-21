
resource "aws_elasticache_serverless_cache" "redis_cluster" {
  engine = "redis"
  name   = "redis"
  cache_usage_limits {
    data_storage {
      minimum = 1
      maximum = 2
      unit    = "GB"
    }
    ecpu_per_second {
      minimum = 1000
      maximum = 2000
    }
  }
  description              = "aurora db caching"
  major_engine_version     = "7"
  security_group_ids       = [data.aws_security_group.redis-sg.id]
  subnet_ids               = [data.aws_subnet.db_subnet1.id, data.aws_subnet.db_subnet2.id]
  
}

data "aws_elasticache_cluster" "redis_cluster" {
  cluster_id = aws_elasticache_serverless_cache.redis_cluster.name
  depends_on = [ aws_elasticache_serverless_cache.redis_cluster ]
}


resource "aws_ssm_parameter" "redis-endpoint" {
  name  = "/config/account/redis-cluster-endpoint"
  type  = "String"
  value = data.aws_elasticache_cluster.redis_cluster.configuration_endpoint

}