#S3
variable "s3_name" {}

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
variable "DB_SUBNET1" {}
variable "DB_CIDR1" {}
variable "DB_SUBNET2" {}
variable "DB_CIDR2" {}
variable "EIP_NAME1" {}
variable "EIP_NAME2" {}
variable "NGW_NAME1" {}
variable "NGW_NAME2" {}
variable "PUBLIC_RT_NAME" {}
variable "PRIVATE_RT_NAME1" {}
variable "PRIVATE_RT_NAME2" {}
variable "DB_RT_NAME1" {}
variable "DB_RT_NAME2" {}

# SECURITY GROUP
variable "WEB_ALB_SG_NAME" {}
variable "APP_ALB_SG_NAME" {}
variable "WEB-SG-NAME" {}
variable "APP_SG_NAME" {}
variable "DB_SG_NAME" {}
variable "REDIS_SG_NAME" {}
variable "BASTION_SG_NAME" {}

# RDS
variable "SG-NAME" {}
variable "RDS-USERNAME" {}
variable "RDS-PWD" {}
variable "DB-NAME" {}
variable "RDS-NAME" {}
variable "DB-INSTANCE-CLASS" {}
variable "DB-USER-ID" {}
variable "DB-USER-PWD" {
    description = "Database user password (8 characters minimum)"
    sensitive   = true
}

# ALB
variable "WEB-TG-NAME" {}
variable "APP-TG-NAME" {}
variable "WEB-ALB-NAME" {}
variable "APP-ALB-NAME" {}

# DB-CACHE

# IAM
variable "IAM-ROLE" {}
variable "IAM-POLICY" {}
variable "INSTANCE-PROFILE-NAME" {}

#AMI
#variable "INSTANCE-PROFILE-NAME" {}

# AUTOSCALING
variable "AMI-NAME" {}
variable "WEB-ASG-NAME" {}
variable "APP-ASG-NAME" {}
variable "AMI-ID" {}

# CLOUDFFRONT / ROUTE53 / ACM
variable "DOMAIN-NAME" {}
variable "CLOUDFRONT-NAME" {}
variable "HEADER-NAME" {}
variable "HEADER-VALUE" {}

# WAFv2
variable "WEB-ACL-NAME" {}

# variable "" {}