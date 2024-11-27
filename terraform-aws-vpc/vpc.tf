# Provision aws production-vpc.
# Public and private subnets association.

# "CIDR" stands for "Classless Inter-Domain Routing" 
# A method for allocating IP addresses within a network
# ------------------------------------------------------------------

resource "aws_vpc" "production-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Production-VPC"
  }
}


# Provision public-subnet - associated to production-vpc (Virtual Private Cloud)
resource "aws_subnet" "public-subnet" {
  cidr_block        = var.public_subnet_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "us-east-2a"

  tags = {
    Name = "Public-Subnet-1"
  }
}

# Provision private-subnet - associated to production-vpc (Virtual Private Cloud)
resource "aws_subnet" "private-subnet" {
  cidr_block        = var.private_subnet_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "us-east-2a"

  tags = {
    Name = "Private-Subnet-1"
  }
}

# Provision public-route-table - not complet
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name = "Public-Route-Table"
  }
}

# Provision public-route-table - not complet
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name = "Private-Route-Table"
  }
}

# Route table association
# Complete subnets by attaching to the right subnet-types
# ------------------------------------------------------------------

resource "aws_route_table_association" "public-subnet-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet.id
}

resource "aws_route_table_association" "private-subnet-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet.id
}



# AWS Elecatic IP must be created before AWS Nat-Gateway

resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "Production-EIP"
  }
}

# Associate aws elestic-ip to Nat-Gateway and public-subnet
# Allowing private resources access internet
# ------------------------------------------------------------------

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "Production-NAT-GW"
  }
  depends_on = [aws_eip.elastic-ip-for-nat-gw]
}

# Nat-gateway interacts with private-route-table
# Would provide internet to private-subnet when public route table is associated to internet-gateway.
resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Internet gateway association with the 
resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name = "Production-IGW"
  }
}

# Provision internet-gateway with public-route-table
# Public-route gets requests from internet-gateay and pass into the public-route-table
# Associate public-route-table to production-internet-gateway
resource "aws_route" "public-internet-gw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
