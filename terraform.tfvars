# VPC
VPC-NAME         = "kdt-VPC"
VPC-CIDR         = "10.50.0.0/16"
IGW-NAME         = "kdt-Interet-Gateway"
PUBLIC-CIDR1     = "10.50.0.0/24"
PUBLIC-SUBNET1   = "kdt-Public-Subnet1"
PUBLIC-CIDR2     = "10.50.1.0/24"
PUBLIC-SUBNET2   = "kdt-Public-Subnet2"
PRIVATE-CIDR1    = "10.50.4.0/24"
PRIVATE-SUBNET1  = "kdt-Private-Subnet1"
PRIVATE-CIDR2    = "10.50.8.0/24"
PRIVATE-SUBNET2  = "kdt-Private-Subnet2"
DB-CIDR1         = "10.50.20.0/24"
DB-SUBNET1       = "kdt-DB-Subnet1"
DB-CIDR2         = "10.50.21.0/24"
DB-SUBNET2       = "kdt-DB-Subnet2"
EIP-NAME1        = "kdt-Elastic-IP1"
EIP-NAME2        = "kdt-Elastic-IP2"
NGW-NAME1        = "kdt-NAT1"
NGW-NAME2        = "kdt-NAT2"
PUBLIC-RT-NAME1  = "kdt-Public-Route-table1"
PUBLIC-RT-NAME2  = "kdt-Public-Route-table2"
PRIVATE-RT-NAME1 = "kdt-Private-Route-table1"
PRIVATE-RT-NAME2 = "kdt-Private-Route-table2"
DB-RT-NAME1 = "kdt-DB-Route-table1"
DB-RT-NAME2 = "kdt-DB-Route-table2"

# SECURITY GROUP
ALB-SG-NAME = "kdt-alb-sg"
WEB-SG-NAME = "kdt-web-sg"
DB-SG-NAME  = "kdt-db-sg"

# RDS
SG-NAME           = "kdt-rds-sg"
RDS-USERNAME      = "admin"
RDS-PWD           = "Admin1234"
DB-NAME           = "mydb"
RDS-NAME          = "kdt-RDS"
DB-INSTANCE-CLASS = "db.t3.medium"

# ALB
TG-NAME  = "Web-TG"
WEB-ALB-NAME = "Web-elb"
APP-ALB-NAME = "App-elb"

# IAM
IAM-ROLE              = "iam-role-for-ec2-SSM"
IAM-POLICY            = "iam-policy-for-ec2-SSM"
INSTANCE-PROFILE-NAME = "iam-instance-profile-for-ec2-SSM"

# AUTOSCALING
AMI-NAME             = "New-AMI"
LAUNCH-TEMPLATE-NAME = "Web-template"
ASG-NAME             = "kdt-ASG"


# CLOUDFFRONT / WAFv2 / ROUTE53 / ACM
DOMAIN-NAME  = "hellowaws.shop"
CDN-NAME     = "kdt-CDN-ktd"
WEB-ACL-NAME = "kdt-WAF-ktd"