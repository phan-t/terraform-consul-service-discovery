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

variable "public_subnet_ids" {
  description = "Public subnets ids"
  # type        = list
}

variable "security_group_ssh_id" {
  description = "Security group ssh ids"
  # type        = string
}

variable "security_group_consul_id" {
  description = "Security group consul ids"
  # type        = string
}

variable "security_group_fake_service_id" {
  description = "Security group fake-service ids"
  # type        = string
}

variable "consul_server_private_fqdn" {
  description = "Server private fqdn"
  # type        = string
}

variable "consul_serf_lan_port" {
  description = "Consul serf lan port"
  type        = number
}

variable "ami_fake_service" {
  description = "AMI of fake-service"
  type        = string
}