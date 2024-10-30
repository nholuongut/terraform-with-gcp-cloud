variable "billing_account_id" {
  description = "The ID of the billing account to attach to each project"
  type        = string
}

variable "folder_name" {
  description = "The name of the folder to create"
  type        = string
}

variable "org_name" {
  description = "The parent organization of the folder"
  type        = string
}

variable "project_name" {
  description = "The name of the project to create in the folder"
  type        = string
}

variable "enabled_apis" {
  description = "List of APIs to enable for the project"
  type        = list(string)
  default     = []
}

variable "auto_create_network" {
  description = "Create a default network for the project"
  type        = bool
  default     = false
}

variable "role_bindings" {
  description = "A list of roles to bind the IAM policy for the project's service account"
  type        = list(string)
  default     = []
}

variable "service_account_elevated_privileges" {
  description = "Add organization-wide roles to the terraform service account.  Set just once."
  type        = bool
  default     = false
}

variable "default_role_bindings" {
  description = "The default list of roles to bind to the project service account"
  type        = list(string)
  default = [
    "roles/apigateway.admin",
    "roles/bigquery.dataOwner",
    "roles/bigquery.user",
    "roles/browser",
    "roles/cloudfunctions.admin",
    "roles/cloudkms.admin",
    "roles/cloudsql.admin",
    "roles/compute.admin",
    "roles/compute.securityAdmin",
    "roles/container.admin",
    "roles/container.clusterAdmin",
    "roles/container.developer",
    "roles/containeranalysis.admin",
    "roles/datastore.owner",
    "roles/dns.admin",
    "roles/iam.roleAdmin",
    "roles/iam.securityReviewer",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/logging.admin",
    "roles/monitoring.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/storage.admin",
    "roles/iap.admin"
  ]
}

variable "terraform_impersonators" {
  description = "The list of users that impersonate the terraform servie account"
  type        = list(string)
  default     = []
}

variable "default_enabled_apis" {
  description = "A default set of APIs to enable"
  type        = list(string)
  default = [
    "cloudbilling.googleapis.com",
    "compute.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "storage-component.googleapis.com",
    "storagetransfer.googleapis.com",
    "servicenetworking.googleapis.com",
    "firewallinsights.googleapis.com",
    "domains.googleapis.com",
    "dns.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudtrace.googleapis.com",
    "clouderrorreporting.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "containerscanning.googleapis.com",
    "containerthreatdetection.googleapis.com",
    "sql-component.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudidentity.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

variable "terraform_id" {
  description = "The project ID used within Terraform to guarantee uniqueness"
  type        = string
  default     = null
}

variable "labels" {
  description = "Extra tags to apply to created resources"
  type        = map(string)
  default     = {}
}

locals {
  enabled_apis  = length(var.enabled_apis) == 0 ? var.default_enabled_apis : var.enabled_apis
  role_bindings = length(var.role_bindings) == 0 ? var.default_role_bindings : var.role_bindings
  labels = merge({
    organization_id = replace(lower(var.org_name), ".", "_")
    billing_account = replace(lower(var.billing_account_id), ".", "_")
    terraform_id    = replace(lower(var.terraform_id), ".", "_")
  }, var.labels)
}
