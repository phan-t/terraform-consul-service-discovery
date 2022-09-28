locals {
  deployment_id = lower("${var.deployment_name}-${random_string.suffix.result}")
  # fake_services = flatten([
  #   for dc, dcs in var.datacenter_config : [
  #     for name, config in dcs.fake_services : {
  #       dc     = dc
  #       name   = name
  #       config = config
  #     }
  #   ]
  # ])
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "local_file" "consul-ent-license" {
  content = var.consul_ent_license
  filename = "${path.root}/consul-ent-license.hclic"
}

module "infra-aws" {
  source  = "./modules/infra/aws"

  region                             = var.aws_region
  deployment_id                      = local.deployment_id
  owner                              = var.owner
  ttl                                = var.ttl
  key_pair_key_name                  = var.aws_key_pair_key_name
  datacenter_config                  = var.datacenter_config
  cluster_version                    = var.aws_eks_cluster_version
  cluster_service_cidr               = var.aws_eks_cluster_service_cidr
  self_managed_node_instance_type    = var.aws_eks_self_managed_node_instance_type
  self_managed_node_desired_capacity = var.aws_eks_self_managed_node_desired_capacity
  consul_serf_lan_port               = var.consul_serf_lan_port
}

# module "k8s-consul-server-dc1" {
#   source = "./modules/consul/aws/kubernetes/consul-server-dc1"
#   providers = {
#     kubernetes = kubernetes.dc1,
#     helm       = helm.dc1
#   }

#   deployment_name    = var.deployment_name
#   datacenter_config  = var.datacenter_config
#   helm_chart_version = var.consul_helm_chart_version
#   consul_version     = var.consul_version
#   ent_license        = var.consul_ent_license
#   replicas           = var.consul_replicas
#   serf_lan_port      = var.consul_serf_lan_port

#   depends_on = [
#     module.infra-aws
#   ]
# }

# module "k8s-consul-server-dc2" {
#   source = "./modules/consul/aws/kubernetes/consul-server-dc2"
#   providers = {
#     kubernetes = kubernetes.dc2,
#     helm       = helm.dc2
#   }

#   deployment_name      = var.deployment_name
#   datacenter_config  = var.datacenter_config
#   helm_chart_version   = var.consul_helm_chart_version
#   consul_version       = var.consul_version
#   ent_license          = var.consul_ent_license
#   federation_secret    = module.consul-server-dc1.federation_secret
#   replicas             = var.consul_replicas
#   serf_lan_port        = var.consul_serf_lan_port
#   cluster_api_endpoint = module.infra-aws.eks_cluster_api_endpoints["dc2"]

#   depends_on = [
#     module.consul-server-dc1
#   ]
# }

module "asg-consul-server-dc1" {
  source = "./modules/consul/aws/autoscaling-group/consul-servers-dc1"

  deployment_id             = local.deployment_id
  owner                     = var.owner
  ttl                       = var.ttl
  key_pair_key_name         = var.aws_key_pair_key_name
  datacenter_config         = var.datacenter_config
  # private_subnet_ids        = module.infra-aws.vpc_private_subnet_ids
  private_subnet_ids        = module.infra-aws.vpc_public_subnet_ids
  security_group_ssh_id     = module.infra-aws.sg_ssh_ids
  security_group_consul_id  = module.infra-aws.sg_consul_ids
  ami_consul_server_asg     = var.ami_consul_server_asg

}

# module "fake-services" {
#   source = "./modules/fake-services/aws"

#   owner                              = var.owner
#   ttl                                = var.ttl
#   key_pair_key_name                  = var.aws_key_pair_key_name
#   datacenter_config                  = var.datacenter_config
#   public_subnet_ids                  = module.infra-aws.vpc_public_subnet_ids
#   security_group_ssh_id              = module.infra-aws.sg_ssh_ids
#   security_group_consul_id           = module.infra-aws.sg_consul_ids
#   security_group_fake_service_id     = module.infra-aws.sg_fake_service_ids
#   consul_server_private_fqdn         = tomap({"dc1" = module.consul-server-dc1.private_fqdn, "dc2" = module.consul-server-dc2.private_fqdn})
#   consul_serf_lan_port               = var.consul_serf_lan_port
#   ami_fake_service                   = var.ami_fake_service
# }