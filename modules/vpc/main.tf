// Variables

variable "project_id" { type = string }
variable "region" { type = string }
variable "network_name" { type = string }
variable "routing_mode" { default = "GLOBAL" }
variable "subnets" {
  type        = list(map(string))
  description = "list of subnets to be created"
  default = [{
    subnet_name           = "subnet-01"
    subnet_ip             = "10.10.20.0/24"
    subnet_region         = "europe-west2"
    subnet_private_access = "true"
    subnet_flow_logs      = "true"
    description           = "1st Subnet"
  }]
}
variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "secondary ranges for use in some subnets"
  default     = {}
}
variable "routes" {
  type        = list(map(string))
  description = "list of routes for the vpc"
  default = [{
    name              = "egress-internet"
    description       = "route through IGW to access internet"
    destination_range = "0.0.0.0/0"
    tags              = "egress-inet"
    next_hop_internet = "true"
  }]
}


// Resources

# Create VPC
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.1"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = var.routing_mode

  subnets = var.subnets

  secondary_ranges = var.secondary_ranges

  routes = var.routes
}


// Outputs

output "vpc" {
  value       = module.vpc
  description = "All outputs"
}
