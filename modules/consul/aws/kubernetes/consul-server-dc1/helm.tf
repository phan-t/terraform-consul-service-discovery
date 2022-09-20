resource "local_file" "consul-server-helm-values" {
  content = templatefile("${path.root}/examples/templates/consul-server-dc1-helm.yml", {
    deployment_name       = "${keys(var.datacenter_config)[0]}"
    consul_version        = var.consul_version
    replicas              = var.replicas
    serf_lan_port         = var.serf_lan_port
    })
  filename = "${path.module}/consul-server-dc1-helm-values.yml.tmp"
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