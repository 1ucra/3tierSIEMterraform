module "s3" {
  source = "./modules/aws-s3"
  s3-name = var.S3-NAME
}

module "vpc" {
  source = "./modules/aws-vpc"

  vpc-name         = var.VPC-NAME
  vpc-cidr         = var.VPC-CIDR
  igw-name         = var.IGW-NAME
  public-cidr1     = var.PUBLIC-CIDR1
  public-subnet1   = var.PUBLIC-SUBNET1
  public-cidr2     = var.PUBLIC-CIDR2
  public-subnet2   = var.PUBLIC-SUBNET2
  private-cidr1    = var.PRIVATE-CIDR1
  private-subnet1  = var.PRIVATE-SUBNET1
  private-cidr2    = var.PRIVATE-CIDR2
  private-subnet2  = var.PRIVATE-SUBNET2
  db-cidr1         = var.DB-CIDR1
  db-subnet1       = var.DB-SUBNET1
  db-cidr2         = var.DB-CIDR2
  db-subnet2       = var.DB-SUBNET2
  eip-name1        = var.EIP-NAME1
  eip-name2        = var.EIP-NAME2
  ngw-name1        = var.NGW-NAME1
  ngw-name2        = var.NGW-NAME2
  public-rt-name   = var.PUBLIC-RT-NAME
  private-rt-name1 = var.PRIVATE-RT-NAME1
  private-rt-name2 = var.PRIVATE-RT-NAME2
  db-rt-name1      = var.DB-RT-NAME1
  db-rt-name2      = var.DB-RT-NAME2
}

module "security-group" {
  source = "./modules/aws-sg"

  vpc-name    = var.VPC-NAME
  web-alb-sg-name = var.WEB-ALB-SG-NAME
  app-alb-sg-name = var.APP-ALB-SG-NAME
  web-sg-name = var.WEB-SG-NAME
  app-sg-name = var.APP-SG-NAME
  db-sg-name  = var.DB-SG-NAME

  depends_on = [module.vpc]

}

module "rds" {
  source = "./modules/aws-rds"

  sg-name              = var.SG-NAME
  db-subnet-name1 = var.DB-SUBNET1
  db-subnet-name2 = var.DB-SUBNET2
  db-sg-name           = var.DB-SG-NAME
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

  public-subnet-name1  = var.PUBLIC-SUBNET1
  public-subnet-name2  = var.PUBLIC-SUBNET2
  private-subnet-name1 = var.PRIVATE-SUBNET1
  private-subnet-name2 = var.PRIVATE-SUBNET2
  web-alb-sg-name      = var.WEB-ALB-SG-NAME
  web-alb-sg-id        = module.security-group.web-alb-sg-id
  app-alb-sg-name      = var.APP-ALB-SG-NAME
  app-alb-sg-id        = module.security-group.app-alb-sg-id
  web-alb-name         = var.WEB-ALB-NAME
  app-alb-name         = var.APP-ALB-NAME
  web-tg-name          = var.WEB-TG-NAME
  app-tg-name          = var.APP-TG-NAME
  vpc-name             = var.VPC-NAME
  header-name = var.HEADER-NAME
  header-value = var.HEADER-VALUE

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
  vpc-name    = var.VPC-NAME
  db-subnet1 = var.DB-SUBNET1
  app-alb-dns-name      = module.alb.app_alb_dns_name

  depends_on = [ module.security-group, module.iam ]
}

module "autoscaling" {
  source = "./modules/aws-autoscaling"
  
  ami-id = module.ami.my-ami-id
  ami_name              = var.AMI-NAME
  instance-profile-name = var.INSTANCE-PROFILE-NAME
  web-sg-name           = var.WEB-SG-NAME
  app-sg-name           = var.APP-SG-NAME
  web-sg-id             = module.security-group.web-tier-sg-id
  app-sg-id             = module.security-group.app-tier-sg-id
  private-subnet-name1  = var.PRIVATE-SUBNET1
  private-subnet-name2  = var.PRIVATE-SUBNET2
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