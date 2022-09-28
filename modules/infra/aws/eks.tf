# module "eks" {
#   source                          = "terraform-aws-modules/eks/aws"
#   version                         = "18.26.3"

#   for_each                        = var.datacenter_config

#   cluster_name                    = "${var.deployment_id}-${each.key}"
#   cluster_version                 = var.cluster_version
#   vpc_id                          = module.vpc["${each.key}"].vpc_id
#   subnet_ids                      = module.vpc["${each.key}"].private_subnets
#   cluster_endpoint_private_access = true
#   cluster_service_ipv4_cidr       = var.cluster_service_cidr

#   eks_managed_node_group_defaults = { 
#   }

#   eks_managed_node_groups = {
#     "${each.key}" = {
#       min_size               = 1
#       max_size               = 3
#       desired_size           = var.self_managed_node_desired_capacity

#       instance_types         = ["m5.large"]
#       key_name               = var.key_pair_key_name
#       vpc_security_group_ids = [module.sg-consul["${each.key}"].security_group_id]
#     }
#   }
  
#   tags = {
#     owner = var.owner
#     TTL = var.ttl
#   }
# }

# resource "null_resource" "kubeconfig" {
#   for_each = var.datacenter_config

#   provisioner "local-exec" {
#     command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks["${each.key}"].cluster_id}"
#   }

#   depends_on = [
#     module.eks
#   ]
# }