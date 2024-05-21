module "s3" {
  source = "./modules/aws-s3"
  s3_name = var.s3_name
}

module "vpc" {
  source = "./modules/aws-vpc"

  vpc_name         = var.vpc_name
  vpc_cidr         = var.vpc_cidr
  igw_name         = var.igw_name
  public_cird1     = var.public_cird1
  public_subnet1   = var.public_subnet1
  public_cidr2     = var.public_cidr2
  public_subnet2   = var.public_subnet2
  private_cidr1    = var.private_cidr1
  private_subnet1  = var.private_subnet1
  private_cidr2    = var.private_cidr2
  private_subnet2  = var.private_subnet2
  DB_CIDR1         = var.DB_CIDR1
  DB_SUBNET1       = var.DB_SUBNET1
  DB_CIDR2         = var.DB_CIDR2
  DB_SUBNET2       = var.DB_SUBNET2
  EIP_NAME1        = var.EIP_NAME1
  EIP_NAME2        = var.EIP_NAME2
  NGW_NAME1        = var.NGW_NAME1
  NGW_NAME2        = var.NGW_NAME2
  PUBLIC_RT_NAME   = var.PUBLIC_RT_NAME
  PRIVATE_RT_NAME1 = var.PRIVATE_RT_NAME1
  PRIVATE_RT_NAME2 = var.PRIVATE_RT_NAME2
  DB_RT_NAME1      = var.DB_RT_NAME1
  DB_RT_NAME2      = var.DB_RT_NAME2
}

module "security-group" {
  source = "./modules/aws-sg"

  vpc_name    = var.vpc_name
  WEB_ALB_SG_NAME = var.WEB_ALB_SG_NAME
  APP_ALB_SG_NAME = var.APP_ALB_SG_NAME
  WEB-SG-NAME = var.WEB-SG-NAME
  APP_SG_NAME = var.APP_SG_NAME
  DB_SG_NAME  = var.DB_SG_NAME
  REDIS_SG_NAME = var.REDIS_SG_NAME
  BASTION_SG_NAME = var.BASTION_SG_NAME

  depends_on = [module.vpc]

}

module "rds" {
  source = "./modules/aws-rds"

  sg-name              = var.SG-NAME
  db-subnet-name1 = var.DB_SUBNET1
  db-subnet-name2 = var.DB_SUBNET2
  DB_SG_NAME           = var.DB_SG_NAME
  rds-username         = var.RDS-USERNAME
  rds-pwd              = var.RDS-PWD
  db-name              = var.DB-NAME
  rds-name             = var.RDS-NAME
  db-instance-class    = var.DB-INSTANCE-CLASS
  db-sg-id             = module.security-group.database-sg-id
  db-user-id = var.DB-USER-ID
  db-user-pwd = var.DB-USER-PWD
  depends_on = [module.security-group]

}

module "alb" {
  source = "./modules/aws-alb"

  public-subnet-name1  = var.public_subnet1
  public-subnet-name2  = var.public_subnet2
  private-subnet-name1 = var.private_subnet1
  private-subnet-name2 = var.private_subnet2
  WEB_ALB_SG_NAME      = var.WEB_ALB_SG_NAME
  web-alb-sg-id        = module.security-group.web-alb-sg-id
  APP_ALB_SG_NAME      = var.APP_ALB_SG_NAME
  app-alb-sg-id        = module.security-group.app-alb-sg-id
  web-alb-name         = var.WEB-ALB-NAME
  app-alb-name         = var.APP-ALB-NAME
  web-tg-name          = var.WEB-TG-NAME
  app-tg-name          = var.APP-TG-NAME
  vpc_name             = var.vpc_name
  header-name = var.HEADER-NAME
  header-value = var.HEADER-VALUE

  depends_on = [module.security-group]
}

module "db-cache" {
  source = "./modules/aws-elasticache"
  
  DB_SUBNET1 = var.DB_SUBNET1
  DB_SUBNET2 = var.DB_SUBNET2
  REDIS_SG_NAME = var.REDIS_SG_NAME

  depends_on = [module.security-group]
}

module "iam" {
  source = "./modules/aws-iam"

  iam-role              = var.IAM-ROLE
  iam-policy            = var.IAM-POLICY
  instance-profile-name = var.INSTANCE-PROFILE-NAME
  
}

module "ami" {
  source ="./modules/aws-ami"

  instance-profile-name = var.INSTANCE-PROFILE-NAME
  vpc_name    = var.vpc_name
  DB_SUBNET1 = var.DB_SUBNET1
  app-alb-dns-name      = module.alb.app_alb_dns_name

  depends_on = [ module.security-group, module.iam ]
}

module "autoscaling" {
  source = "./modules/aws-autoscaling"
  
  ami-id = module.ami.my-ami-id
  ami_name              = var.AMI-NAME
  instance-profile-name = var.INSTANCE-PROFILE-NAME
  WEB-SG-NAME           = var.WEB-SG-NAME
  APP_SG_NAME           = var.APP_SG_NAME
  web-sg-id             = module.security-group.web-tier-sg-id
  app-sg-id             = module.security-group.app-tier-sg-id
  private-subnet-name1  = var.private_subnet1
  private-subnet-name2  = var.private_subnet2
  web-asg-name          = var.WEB-ASG-NAME
  app-asg-name          = var.APP-ASG-NAME
  web-tg-arn            = module.alb.web_tg_arn
  app-tg-arn            = module.alb.app_tg_arn
  app-alb-dns-name      = module.alb.app_alb_dns_name
  depends_on            = [module.ami]
}

module "acm-route53-cloudfront-waf" {
  source = "./modules/aws-acm-route53-cloudfront-waf"

  domain-name     = var.DOMAIN-NAME
  cloudfront-name = var.CLOUDFRONT-NAME
  alb-dns-name    = module.alb.web_alb_dns_name
  web-acl-name    = var.WEB-ACL-NAME
  header-name = var.HEADER-NAME
  header-value = var.HEADER-VALUE

  providers = {
    aws = aws.us-east-1
  }

  depends_on = [module.autoscaling]
}