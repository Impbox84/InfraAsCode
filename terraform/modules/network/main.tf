resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = var.env_name
    }
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_cidr

    tags = {
        Name = "${var.env_name}-private-subnet"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidr

    tags = {
        Name = "${var.env_name}-public-subnet"
    }
}

resource "aws_eip" "nat_ip" {
    domain = "vpc"
    tags = {
        Name = "${var.env_name}-nat-eip"
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat_ip.id
    subnet_id = aws_subnet.public.id

    tags = {
        Name = "${var.env_name}-nat-gateway"
    }

    depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.env_name}-internet-gateway"
    }
}

resource "aws_route_table" "private_table" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.env_name}-private-table"
    }
}

resource "aws_route_table" "public_table" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.env_name}-public-table"
    }
}

resource "aws_route_table_association" "private_table_association" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private_table.id
}

resource "aws_route_table_association" "public_table_association" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public_table.id
}

resource "aws_route" "private_route" {
    route_table_id = aws_route_table.private_table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
}