output "vpc_ids" {
  value = {for k, v in module.vpc : k => v.vpc_id}
}

output "vpc_public_subnet_ids" {
  value = {for k, v in module.vpc : k => v.public_subnets}
}

output "vpc_private_subnet_ids" {
  value = {for k, v in module.vpc : k => v.private_subnets}
}

output "sg_ssh_ids" {
  value = {for k, v in module.sg-ssh : k => v.security_group_id}
}

output "sg_elb_consul_ids" {
  value = {for k, v in module.sg-elb-consul : k => v.security_group_id}
}

output "sg_consul_ids" {
  value = {for k, v in module.sg-consul : k => v.security_group_id}
}

output "sg_consul_wan_ids" {
  value = {for k, v in module.sg-consul-wan : k => v.security_group_id}
}

output "sg_fake_service_ids" {
  value = {for k, v in module.sg-fake-service : k => v.security_group_id}
}

# output "eks_cluster_ids" {
#   value = {for k, v in module.eks : k => v.cluster_id}
# }

# output "eks_cluster_api_endpoints" {
#   value = {for k, v in module.eks : k => v.cluster_endpoint}
# }