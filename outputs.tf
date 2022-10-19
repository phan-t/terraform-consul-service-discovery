# output "dc1-ui_public_fqdn" {
#   description = "DC1 ui public fqdn"
#   value       = "https://${module.consul-server-dc1.ui_public_fqdn}"
# }

# output "dc2-ui_public_fqdn" {
#   description = "DC2 ui public fqdn"
#   value       = "https://${module.consul-server-dc2.ui_public_fqdn}"
# }

output "consul_ui_public_address" {
  description = "Consul UI public address"
  value       = "http://${module.asg-consul-server.elb_consul_dns_address}:8500"
}