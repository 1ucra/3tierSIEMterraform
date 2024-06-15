resource "aws_security_group" "bastion-sg" {
  name        = "DBbastion-sg:${formatdate("YYYYMMDD-HHmm", timestamp())}"
  description = "Allow HTTP and HTTPS, auroraDB"
  vpc_id      = data.aws_vpc.hellowaws-vpc.id # 실제 VPC ID로 변경

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_security_group/bastion-sg"
    owner = "ktd-admin"
    
  }
}


resource "aws_security_group" "redis-sg" {
  name        = "redis-sg:${formatdate("YYYYMMDD-HHmm", timestamp())}"
  description = "Security group for Redis Serverless"
  vpc_id      = data.aws_vpc.hellowaws-vpc.id  # 실제 VPC ID로 변경

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
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_security_group/redis-sg"
    owner = "ktd-admin"
  }

  depends_on = [ aws_security_group.app-tier-sg ]
}

resource "aws_security_group" "web-elb-sg" {
  name = "web-elb-sg:${formatdate("YYYYMMDD-HHmm", timestamp())}"
  vpc_id      = data.aws_vpc.hellowaws-vpc.id
  description = "Allow HTTP and HTTPS form AWs CloudFront"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD-HHmm", timestamp())}"
    Name = "aws_security_group/web-elb-sg"
    owner = "ktd-admin"
  }

  depends_on = [ data.aws_vpc.hellowaws-vpc ]
}

resource "aws_security_group_rule" "allow_http_from_cloudfront" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  security_group_id = aws_security_group.web-elb-sg.id
  source_security_group_id = "pl-38a64351"
  description = "Allow HTTP traffic from CloudFront"

  depends_on = [ aws_security_group.web-elb-sg ]
}

resource "aws_security_group_rule" "allow_https_from_cloudfront" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  security_group_id = aws_security_group.web-elb-sg.id
  source_security_group_id = "pl-38a64351"
  description = "Allow HTTPS traffic from CloudFront"
  
  depends_on = [ aws_security_group.web-elb-sg ]
}

resource "aws_security_group" "web-tier-sg" {
  name = "web-tier-sg:${formatdate("YYYYMMDD-HHmm", timestamp())}"
  vpc_id      = data.aws_vpc.hellowaws-vpc.id
  description = "Allow HTTP and HTTPS for WEP elb Only"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web-elb-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web-elb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD-HHmm", timestamp())}"
    Name = "aws_security_group/web-tier-sg"
    owner = "ktd-admin"
  }

  depends_on = [ aws_security_group.web-elb-sg ]
}

resource "aws_security_group" "app-elb-sg" {
  name = "app-elb-sg:${formatdate("YYYYMMDD-HHmm", timestamp())}"
  vpc_id      = data.aws_vpc.hellowaws-vpc.id
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
    createDate = "${formatdate("YYYYMMDD-HHmm", timestamp())}"
    Name = "aws_security_group/app-elb-sg"
    owner = "ktd-admin"
  }

  depends_on = [ aws_security_group.web-tier-sg ]
}

resource "aws_security_group" "app-tier-sg" {
  name = "app-tier-sg:${formatdate("YYYYMMDD-HHmm", timestamp())}"
  vpc_id      = data.aws_vpc.hellowaws-vpc.id
  description = "Allow HTTP and HTTPS from APP elb Only"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.app-elb-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.app-elb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD-HHmm", timestamp())}"
    Name = "aws_security_group/app-tier-sg"
    owner = "ktd-admin"
  }

  depends_on = [ aws_security_group.app-elb-sg ]
}


# Creating Security Group for RDS Instances Tier With  only access to App-Tier elb
resource "aws_security_group" "database-sg" {
  name = "database-sg:${formatdate("YYYYMMDD-HHmm", timestamp())}"
  vpc_id      = data.aws_vpc.hellowaws-vpc.id
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
    createDate = "${formatdate("YYYYMMDD-HHmm", timestamp())}"
    Name = "aws_security_group/database-sg"
    owner = "ktd-admin"
  }

  depends_on = [ aws_security_group.app-tier-sg,aws_security_group.bastion-sg ]
}