resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Allow SSH, HTTP and HTTPS"
  vpc_id      = data.aws_vpc.vpc.id # 실제 VPC ID로 변경
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.BASTION_SG_NAME
  }
}

resource "aws_security_group" "redis-sg" {
  name        = "redis-sg"
  description = "Security group for Redis Serverless"
  vpc_id      = data.aws_vpc.vpc.id  # 실제 VPC ID로 변경

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.app-tier-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.REDIS_SG_NAME
  }
}

resource "aws_security_group" "web-alb-sg" {
  name = "web-alb-sg"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow HTTP and HTTPS for World"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.WEB_ALB_SG_NAME
  }

  depends_on = [ data.aws_vpc.vpc ]
}


resource "aws_security_group" "web-tier-sg" {
  name = "web-tier-sg"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow HTTP and HTTPS for WEP ALB Only"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web-alb-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web-alb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.WEB-SG-NAME
  }

  depends_on = [ aws_security_group.web-alb-sg ]
}

resource "aws_security_group" "app-alb-sg" {
  name = "app-alb-sg"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow HTTP and HTTPS for World"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.web-tier-sg.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.web-tier-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.APP_ALB_SG_NAME
  }

  depends_on = [ aws_security_group.web-tier-sg ]
}

resource "aws_security_group" "app-tier-sg" {
  name = "app-tier-sg"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow HTTP and HTTPS from APP ALB Only"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.app-alb-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.app-alb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.APP_SG_NAME
  }

  depends_on = [ aws_security_group.app-alb-sg ]
}


# Creating Security Group for RDS Instances Tier With  only access to App-Tier ALB
resource "aws_security_group" "database-sg" {
  name = "database-sg"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Protocol Type MySQL/Aurora"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app-tier-sg.id]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.DB_SG_NAME
  }

  depends_on = [ aws_security_group.web-tier-sg ]
}