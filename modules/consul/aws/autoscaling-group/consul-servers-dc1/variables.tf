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

variable "tags" {
  description = "List of extra tag blocks added to the autoscaling group configuration. Each element in the list is a map containing keys 'key', 'value', and 'propagate_at_launch' mapped to the respective values."
  type        = list(object({ key : string, value : string, propagate_at_launch : bool }))
  default     = []
}

variable "lifecycle_hooks" {
  description = "The lifecycle hooks to create that are triggered by the launch event. This is a map where the keys are the name of the hook and the values are an object with the keys and values defined in the lifecycle_hook block of the aws_autoscaling_group resource.  Default is no launch hooks"
  type        = map(any)
  default     = {}

  #    example = {
  #      name = {
  #        default_result          = string : CONTINUE | ABANDON
  #        heartbeat_timeout       = int
  #        lifecycle_transition    = string : "autoscaling:EC2_INSTANCE_LAUNCHING" | "autoscaling:EC2_INSTANCE_TERMINATING"
  #        notification_metadata   = string
  #        notification_target_arn = string
  #        role_arn                = string
  #    }

  validation {
    condition     = alltrue([for x in values(var.lifecycle_hooks) : contains(["CONTINUE", "ABANDON"], lookup(x, "default_result", "CONTINUE"))])
    error_message = "Lifecycle_hooks[x].default_result must be set to either \"CONTINUE\" or \"ABANDON\"."
  }

  validation {
    condition     = alltrue([for x in values(var.lifecycle_hooks) : contains(["autoscaling:EC2_INSTANCE_LAUNCHING", "autoscaling:EC2_INSTANCE_TERMINATING"], lookup(x, "lifecycle_transition", "BLANK"))])
    error_message = "Lifecycle_hooks[x].lifecycle_transition must be set to either \"autoscaling:EC2_INSTANCE_LAUNCHING\" or \"autoscaling:EC2_INSTANCE_TERMINATING\"."
  }
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