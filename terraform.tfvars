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
db_cird1         = "10.50.20.0/24"
db_subnet1       = "kdt_db_subnet1"
db_cird2         = "10.50.21.0/24"
db_subnet2       = "kdt_db_subnet2"
eip_name1        = "kdt_Elastic-IP1"
eip_name2        = "kdt_Elastic-IP2"
ngw_name1        = "kdt_NAT1"
ngw_name2        = "kdt_NAT2"
public_routeTable_name   = "kdt_Public-Route-table"
private_routeTable_name1 = "kdt_Private-Route-table1"
private_routeTable_name2 = "kdt_Private-Route-table2"
db_routeTable_name1      = "kdt_DB-Route-table1"
db_routeTable_name2      = "kdt_DB-Route-table2"

# SECURITY GROUP
web_alb_securityGroup_name = "kdt_web-alb-sg"
app_alb_securityGroup_name = "kdt_app-alb-sg"
webTier_securityGroup_name = "kdt_web-sg"
appTier_securityGroup_name = "kdt_app-sg"
dbTier_securityGroup_name  = "kdt_db-sg"
redis_securityGroup_name = "kdt_redis-sg"
bastion_securityGroup_name = "kdt_bastion-sg"

# RDS
db_securityGroup_name           = "kdt-rds-sg"
rds_username      = "admin"
rds_pwd           = "Admin1234"
db_name           = "mydb"
rds_name          = "kdt_RDS"

# ALB
web_tg_name  = "Web-TG"
app_tg_name  = "App-TG"
web_alb_name = "Web-elb"
app_alb_name = "App-elb"

# IAM
iam_role              = "role-for-ec2-SSM,S3"
IAM-POLICY            = "policy-for-ec2-SSM,S3"
instance_profile_name = "instance-profile-for-ec2-SSM,S3"

# AUTOSCALING
AMI-NAME             = "New-AMI"
web_asg_name         = "kdt_WEB-ASG"
app_asg_name         = "kdt_APP-ASG"
AMI-ID               = "ami-0c754ed8d0a6969fe"

# CLOUDFFRONT / WAFv2 / ROUTE53 / ACM
domain_name     = "hellowaws.shop"
cloudfront_name = "kdt_CLOUDFRONT-ktd"
web_acl_name    = "kdt_WAF-ktd"
header_name = "my-header"
header_value = "kdt"