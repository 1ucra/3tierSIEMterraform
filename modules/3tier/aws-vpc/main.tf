# Creating VPC
resource "aws_vpc" "hellowaws-vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_vpc/hellowaws-vpc"
    owner = "ktd-admin"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hellowaws-vpc.id

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_internet_gateway/igw"
    owner = "ktd-admin"
  }

  depends_on = [ aws_vpc.hellowaws-vpc ]
}

# Creating Public Subnet 1 for Web Tier Instance
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.hellowaws-vpc.id
  cidr_block              = var.public_cird1
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_subnet/public-subnet1"
    owner = "ktd-admin"
  }
}

# Creating Public Subnet 2 for Web Tier Instance
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.hellowaws-vpc.id
  cidr_block              = var.public_cidr2
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_subnet/public-subnet2"
    owner = "ktd-admin"
  }
}

# Creating Private Subnet 1 for RDS Instance
resource "aws_subnet" "private-subnet1" {
  vpc_id                  = aws_vpc.hellowaws-vpc.id
  cidr_block              = var.private_cidr1
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = false

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_subnet/private-subnet1"
    owner = "ktd-admin"
  }
}

# Creating Private Subnet 2 for RDS Instance
resource "aws_subnet" "private-subnet2" {
  vpc_id                  = aws_vpc.hellowaws-vpc.id
  cidr_block              = var.private_cidr2
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = false

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_subnet/private-subnet2"
    owner = "ktd-admin"
  }
}

# Creating DB Subnet 1 for RDS Instance
resource "aws_subnet" "db-subnet1" {
  vpc_id = aws_vpc.hellowaws-vpc.id
  cidr_block = var.db_cird1
  availability_zone = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = false

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_subnet/db-subnet1"
    owner = "ktd-admin"
  }
}

# Creating DB Subnet 2 for RDS Instance
resource "aws_subnet" "db-subnet2" {
  vpc_id = aws_vpc.hellowaws-vpc.id
  cidr_block = var.db_cird2
  availability_zone = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = false

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_subnet/db-subnet2"
    owner = "ktd-admin"
  }
}

# Creating Elastic IP for NAT Gateway 1
resource "aws_eip" "eip1" {
  domain = "vpc"

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_eip/eip1"
    owner = "ktd-admin"
  }
}

# Creating Elastic IP for NAT Gateway 2
resource "aws_eip" "eip2" {
  domain = "vpc"

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_eip/eip2"
    owner = "ktd-admin"
  }
}

# Creating NAT Gateway 1
resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public-subnet1.id

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name =  "aws_nat_gateway/ngw1"
    owner = "ktd-admin"
  }

  depends_on = [ aws_eip.eip1 ]
}

# Creating NAT Gateway 2
resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public-subnet2.id

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name =  "aws_nat_gateway/ngw2"
    owner = "ktd-admin"
  }

  depends_on = [ aws_eip.eip2 ]
}

# Creating Public Route table 1
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.hellowaws-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_route_table/public-rt"
    owner = "ktd-admin"
  }

  depends_on = [ aws_nat_gateway.ngw2 ]
}

# Associating the Public Route table 1 Public Subnet 1
resource "aws_route_table_association" "public-rt-association1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rt.id

  depends_on = [ aws_route_table.public-rt ]
}

# Associating the Public Route table 2 Public Subnet 2
resource "aws_route_table_association" "public-rt-association2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-rt.id

  depends_on = [ aws_route_table.public-rt ]
}


# Creating Private Route table 1
resource "aws_route_table" "private-rt1" {
  vpc_id = aws_vpc.hellowaws-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw1.id
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_route_table/private-rt1"
    owner = "ktd-admin"
  }

  depends_on = [ aws_route_table_association.public-rt-association2 ]
}

# Associating the Private Route table 1 Private Subnet 1
resource "aws_route_table_association" "private-rt-association1" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private-rt1.id

  depends_on = [ aws_route_table.private-rt1 ]
}

# Creating Private Route table 2 
resource "aws_route_table" "private-rt2" {
  vpc_id = aws_vpc.hellowaws-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw2.id
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_route_table/private-rt2"
    owner = "ktd-admin"
  }
  depends_on = [ aws_route_table_association.private-rt-association1 ]
}

# Associating the Private Route table 2 Private Subnet 2
resource "aws_route_table_association" "private-rt-association2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private-rt2.id

  depends_on = [ aws_route_table.private-rt2 ]
}

# Creating DB Route table 1 
resource "aws_route_table" "db-rt1" {
  vpc_id = aws_vpc.hellowaws-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw2.id
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_route_table/db-rt1"
    owner = "ktd-admin"
  }

  depends_on = [ aws_route_table_association.private-rt-association2 ]
}

# Associating the DB Route table 1 DB Subnet 1
resource "aws_route_table_association" "db-rt-association1" {
  subnet_id      = aws_subnet.db-subnet1.id
  route_table_id = aws_route_table.db-rt1.id

  depends_on = [ aws_route_table.db-rt1 ]
}

# Creating DB Route table 2 
resource "aws_route_table" "db-rt2" {
  vpc_id = aws_vpc.hellowaws-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw2.id
  }
  
  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_route_table/db-rt2"
    owner = "ktd-admin"
  }

  depends_on = [ aws_route_table_association.private-rt-association1 ]
}

# Associating the DB Route table 2 DB Subnet 2
resource "aws_route_table_association" "db-rt-association2" {
  subnet_id      = aws_subnet.db-subnet2.id
  route_table_id = aws_route_table.db-rt2.id

  depends_on = [ aws_route_table.db-rt2 ]
}

resource "aws_vpc_endpoint" "s3-gateway" {
  vpc_id            = aws_vpc.hellowaws-vpc.id
  service_name      = "com.amazonaws.ca-central-1.s3"  # 리전 명시
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private-rt1.id,
    aws_route_table.private-rt2.id,
    aws_route_table.db-rt1.id,
    aws_route_table.db-rt2.id
  ]
}