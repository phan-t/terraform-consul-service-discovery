data "kubernetes_service" "consul-ui" {
  metadata {
    name = "consul-ui"
    namespace = "consul"
  }
  
  depends_on = [
    helm_release.consul-server
  ]
}

data "kubernetes_pod" "consul-server" {
  metadata {
    name = "consul-server-0"
    namespace = "consul"
  }

  depends_on = [
    helm_release.consul-server
  ]
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name      = "consul"
  }
}  

resource "kubernetes_secret" "consul-ent-license" {
  metadata {
    name      = "consul-ent-license"
    namespace = "consul"
  }

  data = {
    key = var.ent_license
  }
}

resource "kubernetes_secret" "consul-federation-secret" {
  metadata {
    name = "consul-federation"
    namespace = "consul"
  }

  data = var.federation_secret
}