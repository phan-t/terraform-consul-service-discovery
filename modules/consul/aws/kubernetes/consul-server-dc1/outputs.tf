output "ui_public_fqdn" {
  description = "Consul ui public fqdn"
  value       = data.kubernetes_service.consul-ui.status.0.load_balancer.0.ingress.0.hostname
}

output "federation_secret" {
  description = "Federation secret"
  value       = data.kubernetes_secret.consul-federation-secret.data
}

output "private_fqdn" {
  description = "Private fqdn"
  value       = data.kubernetes_pod.consul-server.spec.0.node_name
}

# output "ingress_gateway_public_fqdn" {
#   description = "Ingress gateway public fqdn"
#   value       = data.kubernetes_service.consul-ingress-gateway.status.0.load_balancer.0.ingress.0.hostname
# }

# output "primary_datacenter_name" {
#   description = "Primary datacenter name"
#   value       = "${var.deployment_name}-aws"
# }