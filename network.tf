# Create VPC
resource "aws_vpc" "hpc_vpc" {
  # cidr_block: 10.0.0.0/16 allows you to use the IP address that 
  # start with “10.0.X.X”. There are 65,536 IP addresses are ready to use.
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name

  # instance_tenancy: if it is true, your ec2 will be the only instance in 
  # an AWS physical hardware. Sounds good but expensive.
  instance_tenancy = "default"

  tags = {
    Name = "hpc_vpc"
  }
}

# Create Public Subnet
resource "aws_subnet" "hpc_subnet_public" {
  vpc_id                  = aws_vpc.hpc_vpc.id
  cidr_block              = "10.0.0.0/24" # 254 IP addresses in this subnet
  map_public_ip_on_launch = "true"        # The only difference between private and 
  # public subnet is this line. 
  # If it is true, it will be a public subnet, 
  # otherwise private.
  tags = {
    Name = "hpc-subnet-public"
  }
}

resource "aws_subnet" "hpc_subnet_private" {
  vpc_id                  = aws_vpc.hpc_vpc.id
  cidr_block              = "10.0.1.0/24" # 254 IP addresses in this subnet
  map_public_ip_on_launch = "false"       # make subnet private, no direct ingress from internet
  tags = {
    Name = "hpc-subnet-private"
  }
}

# Create Internet Gateway, It enables your vpc to connect to the internet
resource "aws_internet_gateway" "hpc_igw" {
  vpc_id = aws_vpc.hpc_vpc.id

  tags = {
    Name = "hpc-igw"
  }
}

# Create Custom Route Table for public subnet. 
# public subnet can reach to the internet by using this.
resource "aws_route_table" "hpc_public_route_table" {
  vpc_id = aws_vpc.hpc_vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.hpc_igw.id
  }

  tags = {
    Name = "hpc-public-route-table"
  }
}

# Associate CRT and Subnet
resource "aws_route_table_association" "hpc_route_table_public_subnet" {
  subnet_id      = aws_subnet.hpc_subnet_public.id
  route_table_id = aws_route_table.hpc_public_route_table.id
}

# Create a Security Group, opened the port 22 for all the internet.
resource "aws_security_group" "allow_ssh_sg" {
  description = "allow ssh inbond traffic"
  vpc_id      = aws_vpc.hpc_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.ingress_openpbs_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/24"]
    }
  }
  tags = {
    name = "allow-ssh-openpbs"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_network_interface" "hpc_interface" {
  for_each        = local.local_host_2_ip
  subnet_id       = aws_subnet.hpc_subnet_public.id
  private_ips     = ["${each.value}"]
  security_groups = ["${aws_security_group.allow_ssh_sg.id}"]
  #  attachment {
  #     instance     = aws_instance.hpc_aws_instance[each.key].id
  #     device_index = 1
  #   }
}
