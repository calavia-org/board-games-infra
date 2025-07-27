resource "aws_vpc" "calavia_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "calavia_subnet" {
  count = var.subnet_count
  vpc_id = aws_vpc.calavia_vpc.id
  cidr_block = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.name}-subnet-${count.index}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "calavia_igw" {
  vpc_id = aws_vpc.calavia_vpc.id

  tags = {
    Name = "${var.name}-igw"
    Environment = var.environment
  }
}

resource "aws_route_table" "calavia_route_table" {
  vpc_id = aws_vpc.calavia_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.calavia_igw.id
  }

  tags = {
    Name = "${var.name}-route-table"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "calavia_route_table_association" {
  count = var.subnet_count
  subnet_id = aws_subnet.calavia_subnet[count.index].id
  route_table_id = aws_route_table.calavia_route_table.id
}