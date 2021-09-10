module "vpc" {
  source                   = "terraform-aws-modules/vpc/aws"
  version                  = "2.77.0"
  cidr                     = "10.0.0.0/16"
  azs                      = data.aws_availability_zones.available.names
  private_subnets          = ["10.0.2.0/28", "10.0.4.0/28"]
  public_subnets           = ["10.0.1.0/28"]
  enable_dns_hostnames     = true
  enable_nat_gateway       = true
  single_nat_gateway       = true
  public_subnet_tags = {
    Name = "${var.env_prefix}-public"
  }
  tags = var.tags
  vpc_tags = {
    Name = "${var.env_prefix}-VPC"
  }
  private_subnet_tags = {
    Name = "${var.env_prefix}-private"
  }
  igw_tags = {
    Name = "${var.env_prefix}-igw"
  }
   nat_gateway_tags = {
    Name = "${var.env_prefix}-natgw"
  }
}

data "aws_availability_zones" "available" {
  state = "available"         # Return all available az in the region
}