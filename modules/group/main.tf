resource "google_cloud_identity_group" "current" {
  display_name = var.display_name
  description = var.description
  parent = var.parent_id
  group_key {
    id = "${var.display_name}@${var.org_domain}"
  }
  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

module "google_group_iam_member" {
  source = "../group_iam_member"
  for_each = { for permission in var.permissions: permission.project_id => permission }
  member = "group:${google_cloud_identity_group.current.display_name}@${var.org_domain}"
  project = each.value.project_id
  roles = each.value.project_roles
}
