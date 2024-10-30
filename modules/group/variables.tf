variable "display_name" {
  type = string
}

variable "description" {
  type = string
  default = "Managed by Terraform"
}

variable "parent_id" {
  type = string
}

variable "org_domain" {
  type = string
}

variable "permissions" {
  type = list(object({project_id = string, project_roles = list(string)}))
}
