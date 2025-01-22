
# Provider Block
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = var.aws_region
   default_tags {
    tags = {
      Environment = "Test"
      Terraform   = "true"
      
    }
  }
}


/* DATA BLOCKS */

# Retrieve the AWS region
data "aws_region" "current" {}
#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}


/* RESOURCE blocks */

#Define the VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags =  {
    Name = "my vpc"
  }
}



resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my internet gateway"
  }
}


resource "aws_route_table" "gateway_route" {
vpc_id = aws_vpc.main.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id 
  }
  tags = {
    Name = "Default gateway route"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id 
  route_table_id = aws_route_table.gateway_route.id 
}

# Define a security group
resource "aws_security_group" "my_security_group" {
  description = "Allow inbound on ipv4 tcp"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "allow_list"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22 
  to_port = 22
  ip_protocol = "tcp"    
  tags = {
    Name = "ingress_rule_allow_ssh"
    Description = "Allow inbound 22/tcp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_https" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443 
  to_port = 443
  ip_protocol = "tcp"    
  tags = {
    Name = "ingress_rule_allow_https"
    Description = "Allow inbound 443/tcp"
  }
}


# This specifies inidividual ports, alternatively you can  all lan traffic that is inbound - see last block 

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_http" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = var.vpc_cidr
  from_port = 80 
  to_port = 80
  ip_protocol = "tcp"    
  tags = {
    Name = "ingress_rule_allow_http"
    Description = "Allow inbound 80/tcp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_ldap" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = var.vpc_cidr
  from_port = 389 
  to_port = 389
  ip_protocol = "tcp"    
  tags = {
    Name = "ingress_rule_allow_ldap"
    Description = "Allow inbound 389/tcp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_ldaps" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = var.vpc_cidr
  from_port = 636 
  to_port = 636
  ip_protocol = "tcp"    
  tags = {
    Name = "ingress_rule_allow_ldap"
    Description = "Allow inbound 636/tcp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_krb_88_udp" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = var.vpc_cidr
  from_port = 88 
  to_port = 88
  ip_protocol = "udp"    
  tags = {
    Name = "ingress_rule_allow_krb_88_udp"
    Description = "Allow inbound 88/udp"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_inbound_krb_464_udp" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = var.vpc_cidr
  from_port = 464 
  to_port = 464
  ip_protocol = "udp"    
  tags = {
    Name = "ingress_rule_allow_krb_464_udp"
    Description = "Allow inbound 464/udp"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_inbound_krb_88_tcp" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = var.vpc_cidr
  from_port = 88 
  to_port = 88
  ip_protocol = "tcp"    
  tags = {
    Name = "ingress_rule_allow_krb_88_tcp"
    Description = "Allow inbound 88/tcp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_inbound_krb_464_tcp" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = var.vpc_cidr
  from_port = 464 
  to_port = 464
  ip_protocol = "tcp"    
  tags = {
    Name = "ingress_rule_allow_krb_464_tcp"
    Description = "Allow inbound 464/tcp"
  }
}



#######   This lets all traffic in from the LAN so there is the option to disregard the above 

resource "aws_vpc_security_group_ingress_rule" "allow_lan" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = var.vpc_cidr
  from_port = -1 
  to_port = -1
  ip_protocol = -1    
  tags = {
    Name = "ingress_rule_allow_lan"
    Description = "Allow all"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = -1
  ip_protocol = -1
  tags = {
    Name = "egress_rule_allow"
  }
}

#Deploy a single public subnets
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true 
  tags = {
    Name = "Public subnet"
  }
}

/*
#Deploy the public subnets
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets 
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value +1)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true 
  tags = {
    Name      = each.key
    Terraform = "true"
  }
}
*/ 

locals {
    enable_instance = true
}

# Resource Block
resource "aws_instance" "rhel9-hosts" {
  # for_each      = var.public_subnets
  key_name      = aws_key_pair.deployer.key_name
  count         = local.enable_instance ? 3 : 0 
  ami           = var.rhel9_ami
  instance_type = "t2.medium"
  associate_public_ip_address = "true" 
  private_ip = "10.0.1.${21 + count.index}" 
  private_dns_name_options {
    hostname_type = "resource-name"
  }
  subnet_id = aws_subnet.public_subnet.id 
  security_groups = [aws_security_group.my_security_group.id]
  tags = {
    Terraform = "true"
    Name      = "rhel9-host ${count.index +1}"
  }

  

  user_data = file("${path.module}/user-install.sh")
}


resource "aws_key_pair" "deployer" {
    key_name = "ssh-key-pair"
    public_key = var.public_key
}


resource "aws_instance" "rhel8-hosts" {
  # for_each      = var.public_subnets
  
  count         = local.enable_instance ? 3 : 0 
  key_name      = aws_key_pair.deployer.key_name
  ami           = var.rhel9_ami
  instance_type = "t2.medium"
  associate_public_ip_address = "true" 
  private_ip = "10.0.1.${11 + count.index}" 
  private_dns_name_options {
    hostname_type = "resource-name"
  }
  subnet_id = aws_subnet.public_subnet.id 
  security_groups = [aws_security_group.my_security_group.id]
  tags = {
    Terraform = "true"
    Name      = "rhel8-host ${count.index +1}"
  }

  user_data = file("${path.module}/user-install.sh")
}


