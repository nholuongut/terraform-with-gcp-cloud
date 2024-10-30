data "google_projects" "selected" {
 filter = "labels.terraform_id:${var.project}"
}

resource "google_project_iam_member" "current" {
  count   = length(var.roles)
  project = data.google_projects.selected.projects[0].project_id
  role    = element(var.roles, count.index)
  member  = var.member
}
