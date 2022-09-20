resource "local_file" "consul-server-helm-values" {
  content = templatefile("${path.root}/examples/templates/consul-server-dc2-helm.yml", {
    deployment_name       = "${keys(var.datacenter_config)[1]}"
    consul_version        = var.consul_version
    replicas              = var.replicas
    serf_lan_port         = var.serf_lan_port
    primary_datacenter    = "${keys(var.datacenter_config)[0]}"
    cluster_api_endpoint  = var.cluster_api_endpoint
    })
  filename = "${path.module}/consul-server-dc2-helm-values.yml.tmp"
}

resource "helm_release" "consul-server" {
  name          = "${var.deployment_name}-consul-server"
  chart         = "consul"
  repository    = "https://helm.releases.hashicorp.com"
  version       = var.helm_chart_version
  namespace     = "consul"
  timeout       = "300"
  wait_for_jobs = true
  values        = [
    local_file.consul-server-helm-values.content
  ]

  depends_on    = [
    kubernetes_namespace.consul,
    kubernetes_secret.consul-ent-license
  ]
}