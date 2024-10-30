terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.53.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
}

provider "google" {
  project = var.create_groups ? var.project_id : null
  alias   = "tokengen"
}

data "google_service_account_access_token" "sa" {
  count                  = var.create_groups ? 1 : 0
  provider               = google.tokengen
  target_service_account = var.terraform_service_account
  lifetime               = "1800s"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email"
  ]
}

provider "google" {
  access_token = length(data.google_service_account_access_token.sa) > 0 ? data.google_service_account_access_token.sa[0].access_token : null
  project      = var.project_id
}

provider "random" {}
