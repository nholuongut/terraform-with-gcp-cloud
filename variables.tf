variable "gcp_region" {
  description = "The Google Cloud region in which to create resources"
  type        = string
  default     = "us-central1"
}

variable "org_domain" {
  description = "The organization in charge of created resources"
  type        = string
  default     = "gregongcp.net"
}

variable "billing_account_id" {
  description = "The ID of the billing account with which to associate this project"
  type        = string
}

variable "terraform_service_account" {
  description = "The service account to use for Terraform"
  type        = string
  default     = null
}

variable "parent_id" {
  description = "The customer ID (customers/CXXXXX - run gcloud beta organizations list)"
  type        = string
}

variable "project_id" {
  description = "The project ID of the service account to impersonate"
  type        = string
  default     = null
}

variable "folders" {
  description = "A list of folders to create"
  type        = list(object({ name = string }))
  default     = [
    {name = "non-prod"},
    {name = "prod"}
  ]
}

variable "projects" {
  description = "A list of objects including folder names, projects, and IAM principals"
  type = list(
    object({
      folder_name                         = string,
      project_name                        = string,
      identifier                          = string,
      enabled_apis                        = list(string),
      auto_create_network                 = bool,
      role_bindings                       = list(string),
      service_account_elevated_privileges = bool,
      terraform_impersonators             = list(string)
  }))

  default = [
    {
      folder_name                         = "non-prod",
      project_name                        = "ops",
      identifier                          = "non-prod-ops",
      enabled_apis                        = [],
      auto_create_network                 = false,
      role_bindings                       = []
      service_account_elevated_privileges = true,
      terraform_impersonators = [
        "user:admin@gregongcp.net",
        "user:devopsgal@gregongcp.net",
        "user:devopsguy@gregongcp.net"
      ]
    },
    {
      folder_name                         = "non-prod",
      project_name                        = "dev",
      identifier                          = "non-prod-dev",
      enabled_apis                        = [],
      auto_create_network                 = false,
      role_bindings                       = []
      service_account_elevated_privileges = false,
      terraform_impersonators = [
        "user:admin@gregongcp.net",
        "user:devopsgal@gregongcp.net",
        "user:devopsguy@gregongcp.net"
      ]
    },
    {
      folder_name                         = "non-prod",
      project_name                        = "qa",
      identifier                          = "non-prod-qa",
      enabled_apis                        = [],
      auto_create_network                 = false,
      role_bindings                       = []
      service_account_elevated_privileges = false,
      terraform_impersonators = [
        "user:admin@gregongcp.net",
        "user:devopsgal@gregongcp.net",
        "user:devopsguy@gregongcp.net"
      ]
    },
    { folder_name                         = "non-prod",
      project_name                        = "uat",
      identifier                          = "non-prod-uat",
      enabled_apis                        = [],
      auto_create_network                 = false,
      role_bindings                       = []
      service_account_elevated_privileges = false,
      terraform_impersonators = [
        "user:admin@gregongcp.net",
        "user:devopsgal@gregongcp.net",
        "user:devopsguy@gregongcp.net"
      ]
    },
    {
      folder_name                         = "prod",
      project_name                        = "ops",
      identifier                          = "prod-ops",
      enabled_apis                        = [],
      auto_create_network                 = false,
      role_bindings                       = []
      service_account_elevated_privileges = false,
      terraform_impersonators = [
        "user:sre@gregongcp.net",
        "user:admin@gregongcp.net"
      ]
    },
    {
      folder_name                         = "prod",
      project_name                        = "prod",
      identifier                          = "prod-prod",
      enabled_apis                        = [],
      auto_create_network                 = false,
      role_bindings                       = []
      service_account_elevated_privileges = false,
      terraform_impersonators = [
        "user:sre@gregongcp.net",
        "user:admin@gregongcp.net"
      ]
    }
  ]
}

variable "networks" {
  description = "A list of shared VPC networks to create"
  type = list(
    object({
      name                            = string,
      host_project_identifier         = string,
      parent_folder_name              = string,
      auto_create_subnets             = bool,
      routing_mode                    = string,
      delete_default_routes_on_create = string,
      cidr_block                      = string,
      gcp_regions                     = list(string),
      subnet_cidr_suffix              = number
  }))

  default = [
    {
      name                            = "non-prod",
      host_project_identifier         = "non-prod-ops",
      parent_folder_name              = "non-prod",
      auto_create_subnets             = false,
      routing_mode                    = "REGIONAL",
      delete_default_routes_on_create = true,
      cidr_block                      = "10.240.0.0/16",
      gcp_regions                     = ["us-central1", "us-east1", "us-east4", "us-west1", "us-west2", "us-west3", "us-west4"],
      subnet_cidr_suffix              = 20
    },
    {
      name                            = "prod",
      host_project_identifier         = "prod-ops",
      parent_folder_name              = "prod",
      auto_create_subnets             = false,
      routing_mode                    = "REGIONAL",
      delete_default_routes_on_create = true,
      cidr_block                      = "10.248.0.0/16",
      gcp_regions                     = ["us-central1", "us-east1", "us-east4", "us-west1", "us-west2", "us-west3", "us-west4"],
      subnet_cidr_suffix              = 20
    }
  ]
}

variable "create_nat_routers" {
  description = "Controls whether Google NAT routers are created"
  type        = bool
  default     = false
}

variable "nat_router_regions" {
  description = "The list of regions in which NAT routers will be configured (additonal costs apply)"
  type        = list(string)
  default     = ["us-central1"]
}

variable "create_groups" {
  description = "Create groups (requires a service account with permissions)"
  type        = bool
  default     = false
}

variable "groups" {
  description = "A list of groups to create."
  type = list(object({
    display_name = string,
    description  = string,
    permissions = list(object({
      project_id    = string,
      project_roles = list(string)
    }))
  }))
  default = []
}

variable "default_group_description" {
  description = "The default description of created Google IAM groups, if not specified"
  type        = string
  default     = "Managed by Terraform"
}

variable "labels" {
  description = "Extra tags to apply to created resources"
  type        = map(string)
  default     = {}
}

locals {
  groups = var.create_groups ? var.groups : []

  labels = merge(
    {
      organization_id = replace(lower(var.org_domain), ".", "_")
      billing_account = replace(lower(var.billing_account_id), ".", "_")
    },
  var.labels)
}
