#S3 
s3_image_bucket_name =  "hellowaws-image-bucket"
s3_artifact_bucket_name = "hellowaws-artifact-bucket"
s3_logs_bucket_name = "hellowaws-logs-bucket"

# VPC
vpc_name         = "hellowaws_VPC"
vpc_cidr         = "10.60.0.0/16"
igw_name         = "hellowaws_Interet-Gateway"
public_cird1     = "10.60.0.0/24"
public_subnet1   = "hellowaws_public_subnet1"
public_cidr2     = "10.60.1.0/24"
public_subnet2   = "hellowaws_public_subnet2"
private_cidr1    = "10.60.4.0/22"
private_subnet1  = "hellowaws_private_subnet1"
private_cidr2    = "10.60.8.0/22"
private_subnet2  = "hellowaws_private_subnet2"
db_cird1         = "10.60.20.0/24"
db_subnet1       = "hellowaws_db_subnet1"
db_cird2         = "10.60.21.0/24"
db_subnet2       = "hellowaws_db_subnet2"
eip_name1        = "hellowaws_Elastic-IP1"
eip_name2        = "hellowaws_Elastic-IP2"
ngw_name1        = "hellowaws_NAT1"
ngw_name2        = "hellowaws_NAT2"
public_routeTable_name   = "hellowaws_Public-Route-table"
private_routeTable_name1 = "hellowaws_Private-Route-table1"
private_routeTable_name2 = "hellowaws_Private-Route-table2"
db_routeTable_name1      = "hellowaws_DB-Route-table1"
db_routeTable_name2      = "hellowaws_DB-Route-table2"

# SECURITY GROUP
web_alb_securityGroup_name = "hellowaws_web-alb-sg"
app_alb_securityGroup_name = "hellowaws_app-alb-sg"
webTier_securityGroup_name = "hellowaws_web-sg"
appTier_securityGroup_name = "hellowaws_app-sg"
dbTier_securityGroup_name  = "hellowaws_db-sg"
redis_securityGroup_name = "hellowaws_redis-sg"
bastion_securityGroup_name = "hellowaws_bastion-sg"

# RDS
db_securityGroup_name           = "hellowaws-rds-sg"
db_name           = "mydb"
rds_name          = "hellowaws_RDS"

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
web_asg_name         = "hellowaws_WEB-ASG"
app_asg_name         = "hellowaws_APP-ASG"
AMI-ID               = "ami-0c754ed8d0a6969fe"

# CLOUDFFRONT / WAFv2 / ROUTE53 / ACM
domain_name     = "hellowaws.shop"
cloudfront_name = "hellowaws_CLOUDFRONT"
web_acl_name    = "hellowaws_WAF"
header_name = "my-header"
header_value = "hellowaws"

#CICD
repository_name = "hellowaws-application-sourcecode"