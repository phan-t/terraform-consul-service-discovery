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

variable "private_subnet_ids" {
  description = "Private subnet ids"
}

variable "security_group_ssh_id" {
  description = "Security group ssh ids"
  # type        = string
}

variable "security_group_consul_id" {
  description = "Security group consul ids"
  # type        = string
}

variable "security_group_consul_wan_id" {
  description = "Security group consul ids"
  # type        = string
}

variable "asg_min_size" {
  description = "ASG minimum size"
  type        = number
  default     = 3
}

variable "asg_max_size" {
  description = "ASG maximum size"
  type        = number
  default     = 5
}

variable "instance_type" {
  description = "EC2 instances type"
  type        = string
  default     = "t3.small"
}

variable "ami_consul_server_asg" {
  description = "AMI of Consul Server Autoscaling Group"
  type        = string
}