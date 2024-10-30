provider "google" {
  version = "~> 3.0"
  project = var.google_project
  alias   = "tokengen"
}

data "google_client_config" "default" {
  provider = google.tokengen
}

data "google_service_account_access_token" "sa" {
  provider = google.tokengen
  target_service_account = var.terraform_service_account
  lifetime = "1800s"

  scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

provider "google" {
  version = "~> 3.0"
  access_token = data.google_service_account_access_token.sa.access_token
  project = var.google_project
}
