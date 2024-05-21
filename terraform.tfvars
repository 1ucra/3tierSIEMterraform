s3_name = "hellowaws-image-bucket"

# VPC
vpc_name         = "kdt_VPC"
vpc_cidr         = "10.50.0.0/16"
igw_name         = "kdt_Interet-Gateway"
public_cird1     = "10.50.0.0/24"
public_subnet1   = "kdt_public_subnet1"
public_cidr2     = "10.50.1.0/24"
public_subnet2   = "kdt_public_subnet2"
private_cidr1    = "10.50.4.0/22"
private_subnet1  = "kdt_private_subnet1"
private_cidr2    = "10.50.8.0/22"
private_subnet2  = "kdt_private_subnet2"
DB_CIDR1         = "10.50.20.0/24"
DB_SUBNET1       = "kdt_DB_SUBNET1"
DB_CIDR2         = "10.50.21.0/24"
DB_SUBNET2       = "kdt_DB_SUBNET2"
EIP_NAME1        = "kdt_Elastic-IP1"
EIP_NAME2        = "kdt_Elastic-IP2"
NGW_NAME1        = "kdt_NAT1"
NGW_NAME2        = "kdt_NAT2"
PUBLIC_RT_NAME   = "kdt_Public-Route-table"
PRIVATE_RT_NAME1 = "kdt_Private-Route-table1"
PRIVATE_RT_NAME2 = "kdt_Private-Route-table2"
DB_RT_NAME1      = "kdt_DB-Route-table1"
DB_RT_NAME2      = "kdt_DB-Route-table2"

# SECURITY GROUP
WEB_ALB_SG_NAME = "kdt_web-alb-sg"
APP_ALB_SG_NAME = "kdt_app-alb-sg"
WEB-SG-NAME = "kdt_web-sg"
APP_SG_NAME = "kdt_app-sg"
DB_SG_NAME  = "kdt_db-sg"
REDIS_SG_NAME = "kdt_redis-sg"
BASTION_SG_NAME = "kdt_bastion-sg"

# RDS
SG-NAME           = "kdt_rds-sg"
RDS-USERNAME      = "admin"
RDS-PWD           = "Admin1234"
DB-NAME           = "mydb"
RDS-NAME          = "kdt_RDS"
DB-INSTANCE-CLASS = "db.t3.medium"

# ALB
WEB-TG-NAME  = "Web-TG"
APP-TG-NAME  = "App-TG"
WEB-ALB-NAME = "Web-elb"
APP-ALB-NAME = "App-elb"

# IAM
IAM-ROLE              = "role-for-ec2-SSM,S3"
IAM-POLICY            = "policy-for-ec2-SSM,S3"
INSTANCE-PROFILE-NAME = "instance-profile-for-ec2-SSM,S3"

# AUTOSCALING
AMI-NAME             = "New-AMI"
WEB-ASG-NAME         = "kdt_WEB-ASG"
APP-ASG-NAME         = "kdt_APP-ASG"
AMI-ID               = "ami-0c754ed8d0a6969fe"

# CLOUDFFRONT / WAFv2 / ROUTE53 / ACM
DOMAIN-NAME     = "hellowaws.shop"
CLOUDFRONT-NAME = "kdt_CLOUDFRONT-ktd"
WEB-ACL-NAME    = "kdt_WAF-ktd"
HEADER-NAME = "my-header"
HEADER-VALUE = "kdt"