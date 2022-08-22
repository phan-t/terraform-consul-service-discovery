variable "region" {
  description = "AWS region"
  type        = string
}

variable "deployment_id" {
  description = "Deployment id"
  type        = string
}

variable "owner" {
  description = "Resource owner identified using an email address"
  type        = string
}

variable "ttl" {
  description = "Resource TTL (time-to-live)"
  type        = number
}

variable "key_pair_key_name" {
  description = "Key pair name"
  type        = string
}

variable "datacenter_config" {
  description = "List of VPCs"
  type        = map
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
}

variable "cluster_service_cidr" {
  description = "EKS cluster service cidr"
  type        = string
}

variable "self_managed_node_instance_type" {
  description = "EKS self managed node instance type"
  type        = string
}

variable "self_managed_node_desired_capacity" {
  description = "EKS self managed node desired capacity"
  type        = number
}

variable "consul_serf_lan_port" {
  description = "Consul serf lan port"
  type        = number
}