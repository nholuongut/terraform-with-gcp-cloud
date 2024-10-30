data "google_organization" "org" {
  domain = var.org_name
}

resource "google_organization_iam_member" "billing_admin" {
  count  = var.service_account_elevated_privileges ? 1 : 0
  org_id = data.google_organization.org.org_id
  role   = "roles/billing.admin"
  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_organization_iam_member" "shared_vpc_admin" {
  count  = var.service_account_elevated_privileges ? 1 : 0
  org_id = data.google_organization.org.org_id
  role   = "roles/compute.xpnAdmin"
  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_organization_iam_member" "service_account_admin" {
  count  = var.service_account_elevated_privileges ? 1 : 0
  org_id = data.google_organization.org.org_id
  role   = "roles/iam.serviceAccountAdmin"
  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_organization_iam_member" "folder_admin" {
  count  = var.service_account_elevated_privileges ? 1 : 0
  org_id = data.google_organization.org.org_id
  role   = "roles/resourcemanager.folderAdmin"
  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_organization_iam_member" "project_lien_modifier" {
  count  = var.service_account_elevated_privileges ? 1 : 0
  org_id = data.google_organization.org.org_id
  role   = "roles/resourcemanager.lienModifier"
  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_organization_iam_member" "organization_admin" {
  count  = var.service_account_elevated_privileges ? 1 : 0
  org_id = data.google_organization.org.org_id
  role   = "roles/resourcemanager.organizationAdmin"
  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_organization_iam_member" "project_creator" {
  count  = var.service_account_elevated_privileges ? 1 : 0
  org_id = data.google_organization.org.org_id
  role   = "roles/resourcemanager.projectCreator"
  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_organization_iam_member" "project_iam_admin" {
  count  = var.service_account_elevated_privileges ? 1 : 0
  org_id = data.google_organization.org.org_id
  role   = "roles/resourcemanager.projectIamAdmin"
  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_organization_iam_member" "service_usage_admin" {
  count  = var.service_account_elevated_privileges ? 1 : 0
  org_id = data.google_organization.org.org_id
  role   = "roles/serviceusage.serviceUsageAdmin"
  member = "serviceAccount:${google_service_account.terraform.email}"
}
