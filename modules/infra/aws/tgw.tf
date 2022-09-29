module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "2.8.0"

  name        = var.deployment_id

  enable_auto_accept_shared_attachments  = true
  ram_allow_external_principals          = false

  vpc_attachments = {
    vpc1 = {
      vpc_id       = module.vpc["dc1"].vpc_id
      subnet_ids   = module.vpc["dc1"].private_subnets
    },
    vpc2 = {
      vpc_id       = module.vpc["dc2"].vpc_id
      subnet_ids   = module.vpc["dc2"].private_subnets
    }
  }
}

resource "aws_route" "dc1_public_tgw_route" {
  for_each                  = var.datacenter_config

  route_table_id            = module.vpc["dc1"].public_route_table_ids[0]
  destination_cidr_block    = "10.200.0.0/16"
  transit_gateway_id        = module.tgw.ec2_transit_gateway_id
}

resource "aws_route" "dc2_public_tgw_route" {
  for_each                  = var.datacenter_config

  route_table_id            = module.vpc["dc2"].public_route_table_ids[0]
  destination_cidr_block    = "10.100.0.0/16"
  transit_gateway_id        = module.tgw.ec2_transit_gateway_id
}
