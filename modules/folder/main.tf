resource "google_folder" "folder" {
  display_name = var.folder_name
  parent       = var.parent_org_id
}
