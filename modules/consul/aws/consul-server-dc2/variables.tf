variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}

variable "helm_chart_version" {
  type        = string
  description = "Helm chart version"
}

variable "consul_version" {
  description = "Consul version"
  type        = string
}

variable "ent_license" {
  description = "Consul enterprise license"
  type        = string
}

variable "federation_secret" {
  description = "Consul federation secret"
  type        = map
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
}

variable "serf_lan_port" {
  description = "Consul serf lan port"
  type        = number
}

variable "cluster_api_endpoint" {
  description = "Address of the kubernetes api server"
  type        = string
}