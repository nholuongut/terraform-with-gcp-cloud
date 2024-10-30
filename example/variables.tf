variable "terraform_service_account" {
  type = string
  description = "The terraform service account to impersonate"
}

variable "google_project" {
  type = string
  description = "The GCP project in which to create resources"
}

variable "bucket_name" {
  type = string
  description = "The name of the Google storage bucket to create"
}
