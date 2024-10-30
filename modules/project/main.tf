data "google_folder" "folder" {
  folder = var.folder_name
}

resource "random_id" "project" {
  byte_length = 4
}

resource "google_project" "project" {
  name                = var.project_name
  project_id          = "${var.project_name}-${random_id.project.dec}"
  folder_id           = data.google_folder.folder.id
  billing_account     = var.billing_account_id
  auto_create_network = var.auto_create_network
  labels              = local.labels
}

resource "google_project_service" "enabled_apis" {
  count                      = length(local.enabled_apis)
  project                    = google_project.project.project_id
  service                    = element(local.enabled_apis, count.index)
  disable_dependent_services = true
}

resource "google_service_account" "terraform" {
  account_id   = "terraform"
  display_name = "terraform"
  description  = "Terraform Infrastructure Provisioner"
  project      = google_project.project.project_id
}

resource "google_project_iam_member" "terraform" {
  count       = length(local.role_bindings)
  role        = element(local.role_bindings, count.index)
  project     = google_project.project.project_id
  member      = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_project_iam_audit_config" "project" {
  project = google_project.project.project_id
  service = "allServices"
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
  audit_log_config {
    log_type = "ADMIN_READ"
  }
}

resource "google_service_account_iam_binding" "terraform_impersonate" {
  service_account_id = google_service_account.terraform.id
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = var.terraform_impersonators
}
