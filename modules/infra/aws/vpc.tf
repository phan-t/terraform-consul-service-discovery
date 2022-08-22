data "aws_availability_zones" "available" {}

module "vpc" {
  source                = "terraform-aws-modules/vpc/aws"
  version               = "3.14.2"

  for_each              = var.datacenter_config

  name                  = "${var.deployment_id}-${each.key}"
  cidr                  = each.value.vpc_cidr
  azs                   = data.aws_availability_zones.available.names
  private_subnets       = each.value.private_subnets
  public_subnets        = each.value.public_subnets
  enable_nat_gateway    = true
  single_nat_gateway    = true
  enable_dns_hostnames  = true

  tags = {
    "kubernetes.io/cluster/${var.deployment_id}-${each.key}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.deployment_id}-${each.key}" = "shared"
    "kubernetes.io/role/elb"                                 = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.deployment_id}-${each.key}" = "shared"
    "kubernetes.io/role/internal-elb"                        = "1"
  }
}