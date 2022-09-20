output "dc1-ui_public_fqdn" {
  description = "DC1 ui public fqdn"
  value       = "https://${module.consul-server-dc1.ui_public_fqdn}"
}

output "dc2-ui_public_fqdn" {
  description = "DC2 ui public fqdn"
  value       = "https://${module.consul-server-dc2.ui_public_fqdn}"
}