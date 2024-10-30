output "project_id" {
  value = google_project.project.project_id
}

output "folder_id" {
  value = data.google_folder.folder.id
}

output "service_account" {
  value = google_service_account.terraform.email
}
