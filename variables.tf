#S3
variable "s3_image_bucket_name" {}
variable "s3_artifact_bucket_name" {}
variable "s3_logs_bucket_name" {}

# VPC
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "igw_name" {}
variable "public_cird1" {}
variable "public_subnet1" {}
variable "public_cidr2" {}
variable "public_subnet2" {}
variable "private_cidr1" {}
variable "private_subnet1" {}
variable "private_cidr2" {}
variable "private_subnet2" {}
variable "db_subnet1" {}
variable "db_cird1" {}
variable "db_subnet2" {}
variable "db_cird2" {}
variable "eip_name1" {}
variable "eip_name2" {}
variable "ngw_name1" {}
variable "ngw_name2" {}
variable "public_routeTable_name" {}
variable "private_routeTable_name1" {}
variable "private_routeTable_name2" {}
variable "db_routeTable_name1" {}
variable "db_routeTable_name2" {}

# SECURITY GROUP
variable "web_elb_securityGroup_name" {}
variable "app_elb_securityGroup_name" {}
variable "webTier_securityGroup_name" {}
variable "appTier_securityGroup_name" {}
variable "dbTier_securityGroup_name" {}
variable "redis_securityGroup_name" {}
variable "bastion_securityGroup_name" {}

# RDS
variable "db_securityGroup_name" {}
variable "db_name" {}
variable "rds_name" {}
variable "db_user_id" {}
variable "db_user_pwd" {
    description = "Database user password (8 characters minimum)"
    sensitive   = true
}

# elb
variable "web_tg_name" {}
variable "app_tg_name" {}
variable "web_elb_name" {}
variable "app_elb_name" {}

# DB-CACHE

# IAM
variable "iam_role" {}
variable "IAM-POLICY" {}
variable "instance_profile_name" {}

#AMI


# AUTOSCALING
variable "AMI-ID" {}
variable "web_asg_name" {}
variable "app_asg_name" {}



# CLOUDFFRONT / ROUTE53 / ACM
variable "domain_name" {}
variable "cloudfront_name" {}
variable "header_name" {}
variable "header_value" {}

# WAFv2
variable "web_acl_name" {}

# CICD
variable "repository_name" {}
