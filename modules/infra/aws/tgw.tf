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