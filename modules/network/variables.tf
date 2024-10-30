variable "name" {
  description = "The name of the network to create"
  type        = string
}

variable "project_id" {
  description = "The project in which to create the network"
  type        = string
}

variable "parent_folder_name" {
  description = "The folder in which to search for service projects"
  type        = string
}

variable "number_of_service_projects" {
  description = "The number of service projects that will be linked to the shared VPC"
  type        = number
}

variable "auto_create_subnets" {
  description = "Whether to automatically create subnets"
  type        = bool
  default     = false
}

variable "routing_mode" {
  description = "Whether to advertise route GLOBALly or REGIONALly"
  type        = string
  default     = "REGIONAL"
}

variable "delete_default_routes_on_create" {
  description = "Whether to delete default routes after creating a network"
  type        = bool
  default     = true
}

variable "gcp_regions" {
  description = "The regions that will host a subnet in the VPC"
  type        = list(string)
  default     = ["us-central1", "us-east1", "us-east4", "us-west1", "us-west2", "us-west3", "us-west4"]
}

variable "create_nat_routers" {
  description = "Controls whether Google NAT routers are created"
  type        = bool
  default     = false
}

variable "nat_router_regions" {
  description = "The regions in which NAT routers will be configured"
  type        = list(string)
  default     = ["us-central1"]
}

variable "cidr_block" {
  description = "The CIDR block of the VPC network to create"
  type        = string
  default     = "10.100.0.0/16"
}

variable "subnet_cidr_suffix" {
  description = "The CIDR suffix of each subnet in the VPC (e.g. /20)"
  type        = number
  default     = 20
}

variable "service_project_service_accounts_count" {
  description = "The list of service accounts to grant compute.networkUser to"
  type        = number
  default     = 0
}

variable "gke_pods_cidr_block" {
  description = "A secondary CIDR block for pods on GKE clusters"
  type        = string
  default     = "100.64.0.0/11"
}

variable "gke_pods_cidr_suffix" {
  description = "The CIDR suffix of each subnet in the VPC (e.g. /20)"
  type        = number
  default     = 16
}

variable "gke_services_cidr_block" {
  description = "A secondary CIDR block for services on GKE clusters"
  type        = string
  default     = "100.96.0.0/11"
}

variable "gke_services_cidr_suffix" {
  description = "The CIDR suffix of each subnet in the VPC (e.g. /20)"
  type        = number
  default     = 16
}

variable "service_project_service_accounts" {
  description = "The list of service accounts to grant compute.networkUser to"
  type        = list(string)
  default     = []
}

locals {
  new_bits = var.subnet_cidr_suffix - tonumber(trimprefix(regex("/[0-9]+$", var.cidr_block), "/"))
  gke_pods_new_bits = var.gke_pods_cidr_suffix - tonumber(trimprefix(regex("/[0-9]+$", var.gke_pods_cidr_block), "/"))
  gke_services_new_bits = var.gke_services_cidr_suffix - tonumber(trimprefix(regex("/[0-9]+$", var.gke_services_cidr_block), "/"))
}
