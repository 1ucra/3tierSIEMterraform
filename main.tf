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
  public-rt-name1  = var.PUBLIC-RT-NAME1
  public-rt-name2  = var.PUBLIC-RT-NAME2
  private-rt-name1 = var.PRIVATE-RT-NAME1
  private-rt-name2 = var.PRIVATE-RT-NAME2
  db-rt-name1 = var.DB-RT-NAME1
  db-rt-name2 = var.DB-RT-NAME2
}

module "security-group" {
  source = "./modules/aws-sg"

  vpc-name    = var.VPC-NAME
  alb-sg-name = var.ALB-SG-NAME
  web-sg-name = var.WEB-SG-NAME
  db-sg-name  = var.DB-SG-NAME

  depends_on = [module.vpc]

}

module "rds" {
  source = "./modules/aws-rds"

  sg-name              = var.SG-NAME
  private-subnet-name1 = var.PRIVATE-SUBNET1
  private-subnet-name2 = var.PRIVATE-SUBNET2
  db-sg-name           = var.DB-SG-NAME
  rds-username         = var.RDS-USERNAME
  rds-pwd              = var.RDS-PWD
  db-name              = var.DB-NAME
  rds-name             = var.RDS-NAME
  db-instance-class    = var.DB-INSTANCE-CLASS
  db-sg-id             = module.security-group.database-sg-id

  depends_on = [module.security-group]

}

module "alb" {
  source = "./modules/aws-alb"

  public-subnet-name1 = var.PUBLIC-SUBNET1
  public-subnet-name2 = var.PUBLIC-SUBNET2
  web-alb-sg-name     = var.ALB-SG-NAME
  web-alb-sg-id       = module.security-group.alb-sg-id
  alb-name            = var.ALB-NAME
  tg-name             = var.TG-NAME
  vpc-name            = var.VPC-NAME

  depends_on = [module.rds]

}

module "iam" {
  source = "./modules/aws-iam"

  iam-role              = var.IAM-ROLE
  iam-policy            = var.IAM-POLICY
  instance-profile-name = var.INSTANCE-PROFILE-NAME

  depends_on = [module.alb]

}

module "autoscaling" {
  source = "./modules/aws-autoscaling"

  ami_name              = var.AMI-NAME
  launch-template-name  = var.LAUNCH-TEMPLATE-NAME
  instance-profile-name = var.INSTANCE-PROFILE-NAME
  web-sg-name           = var.WEB-SG-NAME
  web-sg-id             = module.security-group.web-tier-sg-id
  tg-arn                = module.alb.alb_tg_arn
  iam-role              = var.IAM-ROLE
  private-subnet-name1  = var.PRIVATE-SUBNET1
  private-subnet-name2  = var.PRIVATE-SUBNET2
  asg-name              = var.ASG-NAME

  depends_on = [module.iam]

}

module "waf-cf-acm-route53" {
  source = "./modules/aws-waf-cdn-acm-route53"

  domain-name  = var.DOMAIN-NAME
  cdn-name     = var.CDN-NAME
  alb-dns-name = module.alb.alb_dns_name
  web_acl_name = var.WEB-ACL-NAME

  providers = {
    aws = aws.us-east-1
  }

  depends_on = [module.autoscaling]
}