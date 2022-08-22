 variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
  default     = ""
}

variable "owner" {
  description = "Resource owner identified using an email address"
  type        = string
  default     = ""
}

variable "ttl" {
  description = "Resource TTL (time-to-live)"
  type        = number
  default     = 48
}

variable "datacenter_config" {
  description = "List of tenant configuration"
  type        = map
  default     = {
    dc1 = {
        vpc_cidr            = "10.100.0.0/16"
        public_subnets      = ["10.100.0.0/24", "10.100.1.0/24", "10.100.2.0/24"]
        private_subnets     = ["10.100.100.0/24", "10.100.101.0/24", "10.100.102.0/24"]
        fake_service_names  = ["frontend", "api", "backend"]
        fake_services       = {
            frontend = {
              count         = 1
              upstream_uris = "api.service.consul"
            }
            api = {
              count         = 2
              upstream_uris = "backend.service.consul"
            }
            backend = {
              count         = 2
              upstream_uris = ""
            }
          }
    }
    dc2 = {
        vpc_cidr            = "10.200.0.0/16"
        public_subnets      = ["10.200.0.0/24", "10.200.1.0/24", "10.200.2.0/24"]
        private_subnets     = ["10.200.100.0/24", "10.200.101.0/24", "10.200.102.0/24"]
        fake_service_names  = ["api", "backend"]
        fake_services       = {
            api = {
              count         = 2
              upstream_uris = "backend.service.consul"
            }
            backend = {
              count         = 2
              upstream_uris = ""
            }
          }
    }
  }  
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "aws_key_pair_key_name" {
  description = "Key pair name"
  type        = string
  default     = ""
}

variable "aws_eks_cluster_version" {
  description = "AWS EKS cluster version"
  type        = string
  default     = "1.22"
}

variable "aws_eks_cluster_service_cidr" {
  description = "AWS EKS cluster service cidr"
  type        = string
  default     = "172.20.0.0/18"
}

variable "aws_eks_self_managed_node_instance_type" {
  description = "EKS self managed node instance type"
  type        = string
  default     = "m5.large"
}

variable "aws_eks_self_managed_node_desired_capacity" {
  description = "EKS self managed node desired capacity"
  type        = number
  default     = 2
}

variable "consul_helm_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.47.1"
}

variable "consul_version" {
  description = "Consul version"
  type        = string
  default     = "1.13.1-ent"
}

variable "consul_ent_license" {
  description = "Consul enterprise license"
  type        = string
  default     = ""
}

variable "consul_replicas" {
  description = "Number of Consul replicas"
  type        = number
  default     = 1
}

variable "consul_serf_lan_port" {
  description = "Consul serf lan port"
  type        = number
  default     = 9301
}

variable "ami_fake_service" {
  description = "AMI of fake-service"
  type        = string
  default     = "ami-0f8367177e942cad5"
}